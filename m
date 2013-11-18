Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3KRLYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:24:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37395 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3KRLYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:24:16 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-e8-5289f8df3f5a
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Ray Jui'" <rjui@broadcom.com>, "'Chris Ball'" <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
References: <1382810624-17659-1-git-send-email-rjui@broadcom.com>
 <5277EA3A.4020001@broadcom.com>
In-reply-to: <5277EA3A.4020001@broadcom.com>
Subject: RE: [PATCH v2] mmc: fix host release issue after discard operation
Date: Mon, 18 Nov 2013 20:24:14 +0900
Message-id: <001801cee450$b6648280$232d8780$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7ZjXGc1LVKErjoTOCbjMBVoj34LAKb1Bug
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zY937PzqDDDauFbTY/nojm8XlXXPY
	LI7872e0eDpzM5sDi8es+2fZPA5dWcvo8XmTXABzFJdNSmpOZllqkb5dAlfG/mVdrAXzxCv6
	F11gamCcJtTFyMkhIWAi8e3NaXYIW0ziwr31bCC2kMAyRonN88q6GDnAak7O4+9i5AIKL2KU
	WD5jISuE84dR4vrUNSwgDWwCWhJ/37xhBmkQEXCQeH1XHiTMLGAtsfjGQkaImckSxyc/ZQQp
	4RTQkfg00w4kLCzgLbHt0WqwKSwCqhJX3txlArF5BWwlDsxdyQhhC0r8mHyPBWKknsTHP7cZ
	IWx5ic1r3jJDnKku8eivLsQBRhLLX+lDVIhI7HvxjhHkYAmBY+wS/bsmMUKsEpD4NvkQC0Sr
	rMSmA8yQQJCUOLjiBssERolZSBbPQrJ4FpLFs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4NC9d
	Lzk/dxMjJAb7djDePGB9iDEZaP1EZinR5HxgDOeVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQ
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsa0+zwmB1sOn4s6+WrbpTMCPQtCuL8cLd32M3Du
	0qcCwTv0WN4f9S22vLj7+9Jbgo84jfJY9s3XNhe90nnNyMu089jOd8mtdVt4c53+m/uyXmFy
	Or38QdWxprSc0hN+R1P2S+b7bZQN5fW83jORf761+LGMJxITmqUMFysaBh45WnzF8dCWd2FK
	LMUZiYZazEXFiQADmG0I1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd37PzqDDG428Fpsf72RzeLyrjls
	Fkf+9zNaPJ25mc2BxWPW/bNsHoeurGX0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdonZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd
	35AguB4jAzSQsI4xY/+yLtaCeeIV/YsuMDUwThPqYuTgkBAwkTg5j7+LkRPIFJO4cG89Wxcj
	F4eQwCJGieUzFrJCOH8YJa5PXcMCUsUmoCXx980bZpBmEQEHidd35UHCzALWEotvLGQEsYUE
	kiWOT37KCFLCKaAj8WmmHUhYWMBbYtuj1WBTWARUJa68ucsEYvMK2EocmLuSEcIWlPgx+R4L
	xEg9iY9/bjNC2PISm9e8ZYY4WV3i0V9diAOMJJa/0oeoEJHY9+Id4wRGoVlIBs1CMmgWkkGz
	kLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc48+kdzCuarA4xCjAwajEw6sR1hkk
	xJpYVlyZe4hRgoNZSYR3xQ2gEG9KYmVValF+fFFpTmrxIcZkoD8nMkuJJucD009eSbyhsYmZ
	kaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTCK5AU4yTn3Lvz4Mto8e5X0
	6qkvbhse+8yzL3dtvqLgjdvnp7mxruQ+dGbNse/dErvuf12Walg+a5lsk8RV3da+/hJGg+uK
	vXoyvgG97jNTtCXllkj3Lrm6YMGmt23fjn97OU+xYuY/PjPBDf+U+37W8zFF2gWtfvmQL/dE
	x9JztzQO/cjtcVRVYinOSDTUYi4qTgQABJcatzUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, November 05, 2013, Ray Jui wrote:
> On 10/26/2013 11:03 AM, Ray Jui wrote:
> > Under function mmc_blk_issue_rq, after an MMC discard operation,
> > the MMC request data structure may be freed in memory. Later in
> > the same function, the check of req->cmd_flags & MMC_REQ_SPECIAL_MASK
> > is dangerous and invalid. It causes the MMC host not to be released
> > when it should
Is commit message cut here?


> >
> > This patch fixes the issue by marking the special request down before
> > the discard/flush operation
> >
> > Reported by: Harold (SoonYeal) Yang <haroldsy@broadcom.com>
> > Signed-off-by: Ray Jui <rjui@broadcom.com>
> > Reviewed-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >   drivers/mmc/card/block.c |    7 ++++---
> >   1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> > index 1a3163f..4e8212c 100644
> > --- a/drivers/mmc/card/block.c
> > +++ b/drivers/mmc/card/block.c
> > @@ -1959,6 +1959,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> >   	struct mmc_card *card = md->queue.card;
> >   	struct mmc_host *host = card->host;
> >   	unsigned long flags;
> > +	unsigned int cmd_flags = req ? req->cmd_flags : 0;
> >
> >   	if (req && !mq->mqrq_prev->req)
> >   		/* claim host only for the first request */
> > @@ -1974,7 +1975,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> >   	}
> >
> >   	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
> > -	if (req && req->cmd_flags & REQ_DISCARD) {
> > +	if (cmd_flags & REQ_DISCARD) {
> >   		/* complete ongoing async transfer before issuing discard */
> >   		if (card->host->areq)
> >   			mmc_blk_issue_rw_rq(mq, NULL);
> > @@ -1983,7 +1984,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> >   			ret = mmc_blk_issue_secdiscard_rq(mq, req);
> >   		else
> >   			ret = mmc_blk_issue_discard_rq(mq, req);
> > -	} else if (req && req->cmd_flags & REQ_FLUSH) {
> > +	} else if (cmd_flags & REQ_FLUSH) {
> >   		/* complete ongoing async transfer before issuing flush */
> >   		if (card->host->areq)
> >   			mmc_blk_issue_rw_rq(mq, NULL);
> > @@ -1999,7 +2000,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> >
> >   out:
> >   	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
> > -	     (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK)))
> > +	     (cmd_flags & MMC_REQ_SPECIAL_MASK))
> >   		/*
> >   		 * Release host when there are no more requests
> >   		 * and after special request(discard, flush) is done.
> >
> Hi Seungwon/Chris,
> 
> Have you got a chance to review the MMC discard patch V2? The patch v2
> makes changes from v1 based on Seungwon's review comments.

Adding linux-mmc. It has been omitted.
(+linux-mmc)

CC: Stable <stable@kernel.org>
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks,
Seungwon Jeon

