Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3DJHCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:02:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39735 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3DJHCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:02:45 -0400
X-AuditID: cbfee68d-b7f786d000005188-5a-51650e9383cd
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Will Newton'" <will.newton@gmail.com>,
        "'Bing Zhao'" <bzhao@marvell.com>,
        "'Ashok Nagarajan'" <asnagarajan@chromium.org>,
        "'Paul Stewart'" <pstew@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
 <5146EAB0.1030705@samsung.com>
 <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
 <515E88E3.5070507@samsung.com>
 <003401ce3453$19d1e8c0$4d75ba40$%jun@samsung.com>
 <CAD=FV=V+ZZ0MUtuWKUOgR9NPyAquUjFC6KtHvAP-4iHXAYpjqA@mail.gmail.com>
In-reply-to: <CAD=FV=V+ZZ0MUtuWKUOgR9NPyAquUjFC6KtHvAP-4iHXAYpjqA@mail.gmail.com>
Subject: RE: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
Date: Wed, 10 Apr 2013 16:02:41 +0900
Message-id: <001601ce35b9$652c5870$2f850950$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac40rikrXimS8XjvT0yRPeqvfhdaZAAZypNg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zQ93JfKmBBlvPsVpsXhdvMW/rUVaL
	7a83slmcXXaQzeLGrzZWi8u75rBZHPnfz2hx6vpnNosNd6eyWizcdIjNgctjdsNFFo+ds+6y
	exy6spbR48qJJlaPyQsvMnv0bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXRs/uC2wFa1UqPj96
	zdbA2CHVxcjJISFgItGx8gkrhC0mceHeerYuRi4OIYFljBIdtzvZYYp6n0+CSkxnlHj5bBqU
	84dR4si6FYwgVWwCWhJ/37xhBrFFBLQlXj5YyQxSxCxwikli8tM5YEVCAieZJJq6kkBsToFg
	iXlPZoI1CAtESxxo2wG2jkVAVeLM9oNMIDavgK3EtDc/2SFsQYkfk++xgNjMAnoSH//cZoSw
	5SU2r3kLNIcD6FR1iUd/dUFMEQEjiRfzSiAqRCT2vXjHCHKOhMBEDomVe/pZIVYJSHybfIgF
	olVWYtMBZoiHJSUOrrjBMoFRYhaSxbOQLJ6FZPEsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7N
	S9dLzs/dxAiJ994djLcPWB9iTAZaP5FZSjQ5H5gu8kriDY3NjCxMTUyNjcwtzUgTVhLnVWux
	DhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeGzLo6mzDA1Zegp/fzeTNzZ6oekQfuJp9J4V
	Nky8Sh3PZ3funpr1RmlVXRRLamQaw6RFnxT3SUmoNvz8piW5RyCL9053Y83J4L+M4Wopr6ao
	sKmd4J4VE/HikZD6RO79LEcWOR3xq0+Q+msxX0TnICvn9Uv+7Vs5vUrmiiqtPKXwY/cki6ky
	SizFGYmGWsxFxYkAme9bew0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQd3JfKmBBhN4LTavi7eYt/Uoq8X2
	1xvZLM4uO8hmceNXG6vF5V1z2CyO/O9ntDh1/TObxYa7U1ktFm46xObA5TG74SKLx85Zd9k9
	Dl1Zy+hx5UQTq8fkhReZPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYR1jRs/uC2wFa1UqPj96zdbA2CHVxcjJISFgItH7fBIbhC0mceHeeiCbi0NIYDqj
	xMtn06CcP4wSR9atYASpYhPQkvj75g0ziC0ioC3x8sFKZpAiZoFTTBKTn84BKxISOMkk0dSV
	BGJzCgRLzHsyE6xBWCBa4kDbDnYQm0VAVeLM9oNMIDavgK3EtDc/2SFsQYkfk++xgNjMAnoS
	H//cZoSw5SU2r3kLNIcD6FR1iUd/dUFMEQEjiRfzSiAqRCT2vXjHOIFRaBaSQbOQDJqFZNAs
	JC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSnkmdSOxhXNlgcYhTgYFTi4fXQTwkU
	Yk0sK67MPcQowcGsJMJ78ztQiDclsbIqtSg/vqg0J7X4EGMy0J8TmaVEk/OBaS6vJN7Q2MTM
	yNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhjnpu/y6F72skzI7UtEylLB
	qO86zjkdGTxKWTcYJ+jzHLf2Op72W39NtPz27Wo7DdW9rzidj9wvyBKTP+tlULPaEbu/bbfr
	Hs5zaFj+8DjH153BN+TnXmOOPtO5MuL67JrL+Qc8rr6JMcr+82CXwqI2H7sNFjP3RHlKnVS2
	rv615UvelbS/HflKLMUZiYZazEXFiQAWCKEzaQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 09, 2013, Doug Anderson wrote:
> Seungwon,
> 
> On Mon, Apr 8, 2013 at 5:17 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > I guess Doug are debugging it with wifi, right?
> 
> Yes, we're debugging it on the Samsung ARM Chromebook on a part that
> has an SDIO WiFi module by Marvell.  Bing Zhao (CCed) has a unit in
> hand that generates lots of CRC errors and has been testing patches
> I've sent him.
> 
> 
> > The problem happens when dw_mci_stop_dma is called in the middle of data transfers.
> > If data error occurs in the end of block, EVENT_XFER_COMPLETE might be set. So, it's fine.
> > Actually, dw_mci_idmac_stop_dma stops the dma working, there is no further interrupt for dma
> completion.
> 
> That sounds right to me.
> 
> 
> > There are two solutions we have applied.
> 
> I'm a little confused.  Have you already applied one or both of the
> solutions you list below, or are you proposing them as alternates to
> the patch I submitted?
Yes, first one already has been applied.
I wanted to introduce our fix. Did you try to test with these fixes?

> 
> > #1. deferring the call of dw_mci_stop_dma until EVENT_XFER_COMPLETE flag is set into pending_events.
> > In this case, dma transfer will be continued with error.
> >
> > @@ -1062,7 +1062,6 @@ static void dw_mci_tasklet_func(unsigned long priv)
> >                 case STATE_SENDING_DATA:
> >                         if (test_and_clear_bit(EVENT_DATA_ERROR,
> >                                                &host->pending_events)) {
> > -                               dw_mci_stop_dma(host);
> >                                 if (data->stop)
> >                                         send_stop_cmd(host, data);
> >                                 state = STATE_DATA_ERROR;
> > @@ -1155,6 +1154,9 @@ static void dw_mci_tasklet_func(unsigned long priv)
> >                                                 &host->pending_events))
> >                                 break;
> >
> > +                       dw_mci_stop_dma(host);
> > +                       set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
> > +
> >                         state = STATE_DATA_BUSY;
> >                         break;
> 
> I can't say that I'm quite familiar enough with the intricate details
> of the driver to know whether this is a good idea or guaranteed to
> work.  Do we really think that we'll still get the end of the transfer
> properly if we've seen an error already?  I worry that we won't.
For example, let's pretend data CRC error occurs during data read.
Peer device doesn't know that error occurrence and data transmission still keeps going.
dma will run as long as host doesn't take the stop or see the end of descriptor.
> 
> 
> > #2. set EVENT_XFER_COMPLETE flag when dw_mci_stop_dma is called regardless using_dma.
> >
> > @@ -299,10 +299,9 @@ static void dw_mci_stop_dma(struct dw_mci *host)
> >         if (host->using_dma) {
> >                 host->dma_ops->stop(host);
> >                 host->dma_ops->cleanup(host);
> > -       } else {
> > -               /* Data transfer was stopped by the interrupt handler */
> > -               set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
> >         }
> > +
> > +       set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
> >  }
> 
> This is fairly similar to my patch but goes further.  I believe my
> patch has this effect but only for the call to dw_mci_stop_dma() in
> STATE_SENDING_DATA in the tasklet.  Your affects all 3 calls to
> dw_mci_stop_dma().
> 
> This seems reasonable but I don't have confidence in my understanding
> of this driver's state machine (especially with regards to the error
> conditions) that I can say which is better.  If you think that this is
> a more correct solution than mine then we can give it some testing.
Yes. As a result, both patches prevent tasklet's hanging.
In that regard, two patches give the similar effect.
But I think your fix are just removing the test_bit to wait for EVENT_XFER_COMPLETE.
'clear_bit(...) part which is added might be of no effect.
It doesn't make sense a bit.

<quotation>
 		case STATE_DATA_ERROR:
-			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
-						&host->pending_events))
-				break;
-
+			clear_bit(EVENT_XFER_COMPLETE, &host->pending_events);
</quotation>

Thanks,
Seugwon Jeon
> 
> Thanks!
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

