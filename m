Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab3EPIlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:41:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49658 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab3EPIlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:41:32 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-4b-51949bb8f3f0
Date: Thu, 16 May 2013 08:41:28 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] drivers: video: mxsfb: clean use of devm_ioremap_resource()
To: Laurent Navet <laurent.navet@gmail.com>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130516084056860@jg1.han
Msgkey: 20130516084056860@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130516084056860@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <19650694.136921368693687337.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsVy+t8zA92ds6cEGnz2sbi8aw6bA6PH501y
	AYxRDYw2iUXJGZllqQqpecn5KZl56bZKoSFuuhZKChn5xSW2StFGBsZ6RqYmekYm5nqWBrFW
	RqZKCnmJuam2ShW6UL1KCkXJBUC1uZXFQANyUvWg4nrFqXkpDln5pSCH6BUn5haX5qXrJefn
	KimUJeaUAo1Q0k+YypjR88awYIdoxZQvd9kaGN+IdDFycggJKElMOrmXsYuRg0NCwETi3VVm
	kLCEgJjEhXvr2boYuYBKljFKzGlYzwKRMJG4vaWDBSIxn1Hi79oj7CAJFgFViU2TTjCB2GwC
	6hITfjeDNQgLBEgse3cBbKqIQJrEg3M9zCDNzCBTWw+1MkNcIStxb/JsMJtXQFDi5MwnUNsU
	JI5d+sEGEVeUuPLvGiNEXELizv39rBA2r8SM9qdQ9XIS076ugXpBWuL8rA2MMO8s/v4YKs4v
	cez2DiaIj3klntwPhhmze/MXNghbQGLqmYNQrUB/zV/JDmHzSaxZ+BZqlaDE6WvdzDC997fM
	BfudGejMKd0P2SFsLYkvP/axoXqLA8h2kjjw13oCo/IsJJlZSLpnIelGVrOAkWUVo2hqQXJB
	cVJ6kSFyXG9ihKTA3h2Mtw9YH2LczwiMk4nMUqLJ+cAkmlcSb2hsZmRhamJqbGRuaUahsImp
	hYWJEVWElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwLo9Wik3TaM8w37TciEVU
	d+/qN1Nqjwfxr3Rbl8vdPsdiwyH5NfeW71b8m3amKe+I+f1gNbvJSs9Yl2qmyB+/zPnnq4yH
	Us6aZJ4Nx5OYb3yTbhArl2td0Zpz6dZXbY7VTH/WLGn8V569X/RcMNtFs+OrCv8JMhTdUDdd
	xNUpsFb2kqFAfVa4EktxRqKhFnNRcSIAgpZ/6fQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2TN0ds6cEGvzfZGVxedccNgdGj8+b
	5AIYozJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaKNDIz1jExN9IyMDfSMLWOtDA0MjEyBqhIy
	MnreGBbsEK2Y8uUuWwPjG5EuRk4OIQEliUkn9zKC2BICJhK3t3SwQNhiEhfurWfrYuQCqpnP
	KPF37RF2kASLgKrEpkknmEBsNgF1iQm/m8EahAUCJJa9u8AMYosIpEk8ONfDDNLMLLCMUaL1
	UCszxDZZiXuTZ4PZvAKCEidnPoHapiBx7NIPNoi4osSVf9egLpKQuHN/PyuEzSsxo/0pVL2c
	xLSva5ghbGmJ87M2MMJcvfj7Y6g4v8Sx2zuADuUA631yPxhmzO7NX9ggbAGJqWcOQrUC/TV/
	JTuEzSexZuFbqFWCEqevdTPD9N7fMhfsd2agM6d0P2SHsLUkvvzYx4bqLQ4g20niwF/rCYxy
	s5BkZiHpnoWkG1nNAkaWVYyiqQXJBcVJ6RVGesWJucWleel6yfm5mxjBCerZoh2M/85bH2IU
	4GBU4uE9kTAlUIg1say4MvcQowQHs5II74xUoBBvSmJlVWpRfnxRaU5q8SHGZGAETmSWEk3O
	BybPvJJ4Q2NjEzMTU3MDCwNLc9KElcR5n7VaBwoJpCeWpGanphakFsFsYeLglGpgXKrfpVIQ
	ejeN67nlTLl1Fy7vU9FuecS15eSElsPOT3JuJjc18XIxWWgczDxT9W6jqxbf3ju6bAmtUqtC
	ZeRvN3TPk/n2V+/EhttZmWd28kyzFli81uUUo3rJ7I/n/aPXrTr/KPwq95ZlU7ZnnnB5E3vC
	Zvl/06g9KUdOatVJ/HWcZ1t+QtXOVomlOCPRUIu5qDgRAGVCEx+UAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4G8fdDF020906

Tuesday, May 14, 2013 6:25 PM, Laurent Navet wrote:
> 
> Check of 'res' and calls to dev_err are already done in devm_ioremap_resource,
> so no need to do them twice.
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/video/mxsfb.c |   14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
> index 21223d4..0f3d0fc 100644
> --- a/drivers/video/mxsfb.c
> +++ b/drivers/video/mxsfb.c
> @@ -884,9 +884,10 @@ static int mxsfb_probe(struct platform_device *pdev)
>  		pdev->id_entry = of_id->data;
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Cannot get memory IO resource\n");
> -		return -ENODEV;
> +	host->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(host->base)) {
> +		ret = PTR_ERR(host->base);
> +		goto fb_release;

It makes build warning as below:

drivers/video/mxsfb.c:887:13: warning: 'host' is used uninitialized in this function [-Wuninitialized]
drivers/video/mxsfb.c:965:21: warning: 'fb_info' may be used uninitialized in this function [-Wuninitialized]

It breaks the assignment.
	host = to_imxfb_host(fb_info);

Also, 'goto fb_release;' is not good.
Please use ' return PTR_ERR(host->base);' as below:
+       host->base = devm_ioremap_resource(&pdev->dev, res);
+       if (IS_ERR(host->base))
+               return PTR_ERR(host->base);


Best regards,
Jingoo Han

>  	}
> 
>  	fb_info = framebuffer_alloc(sizeof(struct mxsfb_info), &pdev->dev);
> @@ -897,13 +898,6 @@ static int mxsfb_probe(struct platform_device *pdev)
> 
>  	host = to_imxfb_host(fb_info);
> 
> -	host->base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(host->base)) {
> -		dev_err(&pdev->dev, "ioremap failed\n");
> -		ret = PTR_ERR(host->base);
> -		goto fb_release;
> -	}
> -
>  	host->pdev = pdev;
>  	platform_set_drvdata(pdev, host);
> 
> --
> 1.7.10.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
