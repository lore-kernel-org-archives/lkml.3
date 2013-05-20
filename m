Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3ETB7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 21:59:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26305 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3ETB7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 21:59:31 -0400
X-AuditID: cbfee691-b7fef6d000002d62-e7-51998381171c
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Jon Mason'" <jon.mason@intel.com>,
        cpgs@samsung.com
References: <010301ce54fd$734bce50$59e36af0$%choi@samsung.com>
In-reply-to: <010301ce54fd$734bce50$59e36af0$%choi@samsung.com>
Subject: RE: [PATCH 3.9-stable] NTB: variable dereferenced before check
Date: Mon, 20 May 2013 10:59:29 +0900
Message-id: <010401ce54fd$aa029c80$fe07d580$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAAARZoA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI93G5pmBBp93GFm8PKRpsaSZ2+L4
	j3PsFpd3zWGzWLDxEaMDq8fiPS+ZPPq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvjw6tz7AVb
	pCt2/NrI2sC4UayLkZNDQsBE4sKhLkYIW0ziwr31bF2MXBxCAssYJd68v8MMU3Rp0homiMR0
	RomlT1eAJYQE/jJKTD2TCGKzCehKHFu/hRXEFhHwljg15RdYDbOAv0TnTZh6O4mFU56ygNic
	AvYSu46fYwOxhQXcJSY82AwWZxFQlXi7ZgrYRbxA9Qe2PWKHsAUlfky+xwIxU0ti/c7jTBC2
	vMTmNW+B5nMAHaou8eivLsQJFRLzNjUxQpSISOx78Y4R5H4JgWPsElce/GGC2CUg8W3yIRaI
	XlmJTQeg/pWUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9d
	Lzk/dxMjJCIn7mC8f8D6EGMy0PqJzFKiyfnAiM4riTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQ
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6P18sqgwokpH214I1ISq28vdawN8dQ78850//J4
	lRDVDGsTnU2+0fKlt9im2tXNeBAbfU8qVSNP975BWeA8husf1JYtvi7Y+vuX7aIZ2XzXl/mJ
	dFoaq82t833D87hqaviCCymSFi1Jl++z5mpsMo6RCmt9vE/5cdYpEYYMNvGHT+SUgluYlViK
	MxINtZiLihMBsmGz5N4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd3G5pmBBg/79CxeHtK0WNLMbXH8
	xzl2i8u75rBZLNj4iNGB1WPxnpdMHn1bVjF6fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeY8eHVOfaCLdIVO35tZG1g3CjWxcjJISFgInFp0homCFtM4sK99Wxd
	jFwcQgLTGSWWPl3BDJIQEvjLKDH1TCKIzSagK3Fs/RZWEFtEwFvi1JRfYDXMAv4SnTdh6u0k
	Fk55ygJicwrYS+w6fo4NxBYWcJeY8GAzWJxFQFXi7ZopjCA2L1D9gW2P2CFsQYkfk++xQMzU
	kli/8zgThC0vsXnNW6D5HECHqks8+qsLcUKFxLxNTYwQJSIS+168Y5zAKDQLyaRZSCbNQjJp
	FpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC4/2Z1A7GlQ0WhxgFOBiVeHgzgmYG
	CrEmlhVX5h5ilOBgVhLhtbMGCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MBXllcQbGpuY
	GVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjSpjxZ80FriERF+bM+R41
	K/Cje13w2fLrzRXtpuHSjes3iJUY/1m8juPZXe7Tmi4PF9Q9TkrvD0rsWT3DJFiLZ8HBPKel
	/IKPXlT82L5u9THznddWe5gorTg23Y6tTilZ77jj17kHwiztZ3y6X72J6wtfieafs1Pnuts8
	WzSvi+WRv/mhbwtUlViKMxINtZiLihMBCYPoXjsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Mason agrees that this could also be applied to the 3.9

"Yes, please do.  I'll respond to each of the patch series, but please apply
them all.  Also, one patch was omitted from these, titled
NTB: variable dereferenced before check

Please include that patch in 3.9 stable as well.
"

Thanks.

Best Regards.

> -----Original Message-----
> From: stable-owner@vger.kernel.org [mailto:stable-owner@vger.kernel.org]
> On Behalf Of Jonghwan Choi
> Sent: Monday, May 20, 2013 10:58 AM
> To: 'Jonghwan Choi'; linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org; 'Jon Mason'; cpgs@samsung.com
> Subject: [PATCH 3.9-stable] NTB: variable dereferenced before check
> 
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?
> 
> ------------------
> 
> From: "Jon Mason <jon.mason@intel.com>"
> 
> commit 186f27ff9f9ec5c110739ced88ce9f8fca053882 upstream
> 
> Correct instances of variable dereferencing before checking its value on
> the functions exported to the client drivers.  Also, add sanity checks
> for all exported functions.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/ntb/ntb_transport.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
> index e0bdfd7..74c5812 100644
> --- a/drivers/ntb/ntb_transport.c
> +++ b/drivers/ntb/ntb_transport.c
> @@ -1210,12 +1210,14 @@ EXPORT_SYMBOL_GPL(ntb_transport_create_queue);
>   */
>  void ntb_transport_free_queue(struct ntb_transport_qp *qp)
>  {
> -	struct pci_dev *pdev = ntb_query_pdev(qp->ndev);
> +	struct pci_dev *pdev;
>  	struct ntb_queue_entry *entry;
> 
>  	if (!qp)
>  		return;
> 
> +	pdev = ntb_query_pdev(qp->ndev);
> +
>  	cancel_delayed_work_sync(&qp->link_work);
> 
>  	ntb_unregister_db_callback(qp->ndev, qp->qp_num);
> @@ -1371,12 +1373,13 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_up);
>   */
>  void ntb_transport_link_down(struct ntb_transport_qp *qp)
>  {
> -	struct pci_dev *pdev = ntb_query_pdev(qp->ndev);
> +	struct pci_dev *pdev;
>  	int rc, val;
> 
>  	if (!qp)
>  		return;
> 
> +	pdev = ntb_query_pdev(qp->ndev);
>  	qp->client_ready = NTB_LINK_DOWN;
> 
>  	rc = ntb_read_local_spad(qp->ndev, QP_LINKS, &val);
> @@ -1408,6 +1411,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_down);
>   */
>  bool ntb_transport_link_query(struct ntb_transport_qp *qp)
>  {
> +	if (!qp)
> +		return false;
> +
>  	return qp->qp_link == NTB_LINK_UP;
>  }
>  EXPORT_SYMBOL_GPL(ntb_transport_link_query);
> @@ -1422,6 +1428,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_query);
>   */
>  unsigned char ntb_transport_qp_num(struct ntb_transport_qp *qp)
>  {
> +	if (!qp)
> +		return 0;
> +
>  	return qp->qp_num;
>  }
>  EXPORT_SYMBOL_GPL(ntb_transport_qp_num);
> @@ -1436,6 +1445,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_qp_num);
>   */
>  unsigned int ntb_transport_max_size(struct ntb_transport_qp *qp)
>  {
> +	if (!qp)
> +		return 0;
> +
>  	return qp->tx_max_frame - sizeof(struct ntb_payload_header);
>  }
>  EXPORT_SYMBOL_GPL(ntb_transport_max_size);
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

