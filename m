Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935460Ab3DHMSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:18:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46821 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab3DHMR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:17:58 -0400
X-AuditID: cbfee68d-b7f786d000005188-f4-5162b57428e5
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Chris Ball'" <cjb@laptop.org>, "'Will Newton'" <will.newton@gmail.com>,
        "'Bing Zhao'" <bzhao@marvell.com>,
        "'Ashok Nagarajan'" <asnagarajan@chromium.org>,
        "'Paul Stewart'" <pstew@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
 <5146EAB0.1030705@samsung.com>
 <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
 <515E88E3.5070507@samsung.com>
In-reply-to: <515E88E3.5070507@samsung.com>
Subject: RE: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
Date: Mon, 08 Apr 2013 21:17:55 +0900
Message-id: <003401ce3453$19d1e8c0$4d75ba40$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4x1i5Ojg0eq5IGQTSVZl9Acs4+xAAC0kqA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zY92SrUmBBs+fG1hsXhdvMW/rUVaL
	7a83slmcXXaQzeLGrzZWi8u75rBZHPnfz2hx6vpnNosNd6eyWizcdIjNgctjdsNFFo+ds+6y
	exy6spbR48qJJlaPyQsvMnv0bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXxu9p11kK9ohX3D3Q
	xtrA+Je/i5GTQ0LARGL2zGeMELaYxIV769m6GLk4hASWMUq82dbHCFP0duc3JhBbSGARo8T7
	z8oQRX8YJZp//WIDSbAJaEn8ffOGGcQWEQiXePH2KRNIEbPAPCaJ6fcnM0J0nGOUOLloCthY
	TgFtif/XdoKNFRaIljjQtoMdxGYRUJWY+PMYmM0rYCsxq+EuG4QtKPFj8j0WEJtZQE/i45/b
	jBC2vMTmNW+BNnMAnaou8eivLsQRRhIL+l9DlYtI7HvxDuwGCYGJHBInN+1ihNglIPFt8iEW
	iF5ZiU0HmCE+lpQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchQrzgxt7g0
	L10vOT93EyMk4nt3MN4+YH2IMRlo/URmKdHkfGDCyCuJNzQ2M7IwNTE1NjK3NCNNWEmcV63F
	OlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo+z9PuWJ66ons1XYMqmdEM6wmSn359313zmf
	GS5XiLKy/Eww/lRrVdPi6vhowl+lD4sm7eu8t7gp/eueRwEnKjrCT0zYHqtixvvptsDvror9
	e/7+2z+3mH1aUv3fDHZm7tyzVxnyLknP0UtdI8/n5nnjCKul6zM7888Zk/RrCl743n3Ntfdq
	vhJLcUaioRZzUXEiAO9p1gcOAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jAd2SrUmBBveO81tsXhdvMW/rUVaL
	7a83slmcXXaQzeLGrzZWi8u75rBZHPnfz2hx6vpnNosNd6eyWizcdIjNgctjdsNFFo+ds+6y
	exy6spbR48qJJlaPyQsvMnv0bVnF6PF5k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8
	qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0H1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMI6xozf066zFOwRr7h7oI21gfEvfxcjJ4eEgInE253fmCBsMYkL99azgdhCAosY
	Jd5/Vu5i5AKy/zBKNP/6BZZgE9CS+PvmDTOILSIQLvHi7VMmkCJmgXlMEtPvT2aE6DjHKHFy
	0RRGkCpOAW2J/9d2gq0QFoiWONC2gx3EZhFQlZj48xiYzStgKzGr4S4bhC0o8WPyPRYQm1lA
	T+Ljn9uMELa8xOY1b4E2cwCdqi7x6K8uxBFGEgv6X0OVi0jse/GOcQKj0Cwkk2YhmTQLyaRZ
	SFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOJ8+kdjCubLA4xCjAwajEwyv5IzFQ
	iDWxrLgy9xCjBAezkgjv4cVJgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0x1eSXxhsYm
	ZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAaFuwZtJ1Z/UHj+dOived
	EBqxkr2ddabBmZOmxxnsTpScF1tV5Zvy87/y9+1CocopuXsXfwvYXtvP5/595c/y2re9V979
	cfn74uvHygoeG/kW/tqUuT67zF96rm4MFbwgGLUm9OnhQ3JXVO+ZfPkV/eaqTsBS8+Vtb01d
	SqqDfFu+/15+5s2ShUosxRmJhlrMRcWJAL5ALB9rAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 05, 2013, Jaehoon Chung wrote:
> Hi Doug,
> 
> You're right..it's something wrong.
> Actually i didn't test with your patch, but your commit message is reasonable.
> 
> I will check until next week after test.
Doug Anderson, Jaehoon Chung,

Sorry for late response.
Could I explain this problem more?
I guess Doug are debugging it with wifi, right?
The problem happens when dw_mci_stop_dma is called in the middle of data transfers.
If data error occurs in the end of block, EVENT_XFER_COMPLETE might be set. So, it's fine.
Actually, dw_mci_idmac_stop_dma stops the dma working, there is no further interrupt for dma completion.
There are two solutions we have applied.

#1. deferring the call of dw_mci_stop_dma until EVENT_XFER_COMPLETE flag is set into pending_events.
In this case, dma transfer will be continued with error.

@@ -1062,7 +1062,6 @@ static void dw_mci_tasklet_func(unsigned long priv)
                case STATE_SENDING_DATA:
                        if (test_and_clear_bit(EVENT_DATA_ERROR,
                                               &host->pending_events)) {
-                               dw_mci_stop_dma(host);
                                if (data->stop)
                                        send_stop_cmd(host, data);
                                state = STATE_DATA_ERROR;
@@ -1155,6 +1154,9 @@ static void dw_mci_tasklet_func(unsigned long priv)
                                                &host->pending_events))
                                break;

+                       dw_mci_stop_dma(host);
+                       set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
+
                        state = STATE_DATA_BUSY;
                        break;
                        
#2. set EVENT_XFER_COMPLETE flag when dw_mci_stop_dma is called regardless using_dma.

@@ -299,10 +299,9 @@ static void dw_mci_stop_dma(struct dw_mci *host)
        if (host->using_dma) {
                host->dma_ops->stop(host);
                host->dma_ops->cleanup(host);
-       } else {
-               /* Data transfer was stopped by the interrupt handler */
-               set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
        }
+
+       set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
 }

If you have any opinion, please let me know.

Thanks,
Seungwon Jeon 
> 
> Best Regards,
> Jaehoon Chung
> 
> On 03/27/2013 03:06 AM, Doug Anderson wrote:
> > Jaehoon,
> >
> > On Mon, Mar 18, 2013 at 3:21 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> >> Hi Doug,
> >>
> >> Great..i have found the problem like this.
> >> I will check your patch..and share the result.
> >
> > Did you have any time to check this patch?
> >
> > Thanks!
> >
> > -Doug
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

