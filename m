Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab3FLA7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:59:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61027 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab3FLA7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:59:16 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-b6-51b7c7e2a4b0
Message-id: <51B7C7E3.9050706@samsung.com>
Date: Wed, 12 Jun 2013 09:59:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org, anish198519851985@gmail.com,
        pmeerw@pmeerw.net
Subject: Re: [PATCH 0/5] dwc3: omap: adapt dwc3 to use extcon framework
References: <1370276020-17446-1-git-send-email-kishon@ti.com>
In-reply-to: <1370276020-17446-1-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsWyRsSkRPfR8e2BBoc3m1tcvtHFbHHwfr3F
	zE832SwOzH7IanHgzw5Gi+bF69ksLjztYbNY2LaExeLyrjlsFrOX9LNYLFrWymxxu3EFm8Xv
	XcfYLQ6vOMBkse7ldBYHfo8Fn6+we+ycdZfd49Xqmawed67tYfPYP3cNu8f5GQsZPc43H2H0
	6NuyitHj+I3tTB6fN8kFcEVx2aSk5mSWpRbp2yVwZdyd8ZO5oFug4sDm1cwNjG08XYycHBIC
	JhIXt21lhbDFJC7cW8/WxcjFISSwlFFi582V7DBF/1cdZ4dITGeU2H9pHguE84JR4teMtWBV
	vAJaElfudTGC2CwCqhJXPnYxg9hsQPH9L26wgdiiAmESK6dfYYGoF5T4MfkemC0CVHN65w9m
	kKHMAp+ZJL42rwEaxMEhLOAu0dUL1iskYCtx51Eb2C5OATuJj1tPgs1nFtCR2N86jQ3ClpfY
	vOYt2BwJgbUcEgd/7IE6SEDi2+RDLCAzJQRkJTYdYIb4TFLi4IobLBMYxWYhOWkWkrGzkIxd
	wMi8ilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMw8k//ezZhB+O9A9aHGJOBVk5klhJNzgcm
	jrySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MAZO
	WBA2sYytZLlvxPVPW8KTXnwtWc+sXFsya2+Q+UmXq2/fSE2TmJThvS3HxSbp83f9ysCAasO/
	UQ/mlrr2ctyTedxScv5QXNvbYKEMtcfVf/mq3714ZPvrkaDE5tB99zoV+FInrAmrvra99FT+
	AdlHu/QbWbn8l518WOJRz3lvZ37g3Rv3xZRYijMSDbWYi4oTAVbY6QMSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jQd1Hx7cHGix4rmtx+UYXs8XB+/UW
	Mz/dZLM4MPshq8WBPzsYLZoXr2ezuPC0h81iYdsSFovLu+awWcxe0s9isWhZK7PF7cYVbBa/
	dx1jtzi84gCTxbqX01kc+D0WfL7C7rFz1l12j1erZ7J63Lm2h81j/9w17B7nZyxk9DjffITR
	o2/LKkaP4ze2M3l83iQXwBXVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQ
	l5ibaqvk4hOg65aZA/SHkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj
	7oyfzAXdAhUHNq9mbmBs4+li5OSQEDCR+L/qODuELSZx4d56ti5GLg4hgemMEvsvzWOBcF4w
	SvyasRasildAS+LKvS5GEJtFQFXiyscuZhCbDSi+/8UNNhBbVCBMYuX0KywQ9YISPybfA7NF
	gGpO7/zBDDKUWeAzk8TX5jVAgzg4hAXcJbp6wXqFBGwl7jxqA9vFKWAn8XHrSbD5zAI6Evtb
	p7FB2PISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	rTyT3sG4qsHiEKMAB6MSD+8Bs+2BQqyJZcWVuYcYJTiYlUR4dXOBQrwpiZVVqUX58UWlOanF
	hxiTgSEwkVlKNDkfmPLySuINjU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOF
	iYNTqoFxQfrVDjcHcVnHyF+Cppmnrin/CTj5ZLGUL/OcSgN1yeepASVJZ9TyCk22aKzXmnQ3
	IS3/WTrLvC2/LDjnf9xWHPSwc7umRBLfhlNC2y9oW8Qcf+7zfqZ2S51/dCrjJYlHxzdsaNbv
	+3kkXPoly9u0hVd2htT+WN7B1j7hxe2fS9SjN03VMl+qxFKckWioxVxUnAgAfiOedm8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

I confused patch number. I applied patch2,3 on extcon-linus branch.

  extcon: Kconfig: Make extcon config type as bool
  extcon: add EXPORT_SYMBOL_GPL for exported functions


And I will reply comment about patch1 soon.

  extcon: Add an API to get extcon device from dt node


Thanks,
Chanwoo Choi

On 06/04/2013 01:13 AM, Kishon Vijay Abraham I wrote:
> The first three patches deals with cleanup of extcon inorder to get
> through compilation without any issues. It also adds an API to get
> extcon device from dt node which I felt was missing.
>
> The next two patches deals with adapt dwc3 to use extcon framework.
> The 4th patch (usb: dwc3: omap: improve error handling of dwc3_omap_probe)
> should have ideally been sent to Felipe, however since
> there will be merge conflicts with the 5th patch
> (usb: dwc3: use extcon fwrk to receive connect/disconnect)
> in this series, I've sent in the same series.
>
> Once this patch series get merged, dwc3 in omap would be functional
> in device mode. However there is still some discussion on modelling
> SMPS10 regulator. Once that gets finalized, dwc3 should be functional
> in host mode as well.
>
> Kishon Vijay Abraham I (5):
>   extcon: Add an API to get extcon device from dt node
>   extcon: Kconfig: Make extcon config type as bool
>   extcon: add EXPORT_SYMBOL_GPL for exported functions
>   usb: dwc3: omap: improve error handling of dwc3_omap_probe
>   usb: dwc3: use extcon fwrk to receive connect/disconnect
>
>  Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
>  drivers/extcon/Kconfig                             |    2 +-
>  drivers/extcon/extcon-class.c                      |   42 +++++++
>  drivers/usb/dwc3/dwc3-omap.c                       |  133 ++++++++++++++++----
>  include/linux/extcon.h                             |    8 ++
>  include/linux/usb/dwc3-omap.h                      |   30 -----
>  6 files changed, 168 insertions(+), 52 deletions(-)
>  delete mode 100644 include/linux/usb/dwc3-omap.h
>

