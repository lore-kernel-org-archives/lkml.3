Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3CODGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:06:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47971 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3CODGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:06:02 -0400
X-AuditID: cbfee68e-b7f946d000001e37-48-51429019caa1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Rob Landley'" <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1363302046-31684-1-git-send-email-dianders@chromium.org>
 <1363316303-12736-1-git-send-email-dianders@chromium.org>
In-reply-to: <1363316303-12736-1-git-send-email-dianders@chromium.org>
Subject: Re: [PATCH v2] usb: Document clocks in samsung,exynos4210-ehci/ohci
 bindings
Date: Fri, 15 Mar 2013 12:06:00 +0900
Message-id: <007c01ce212a$059e3340$10da99c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hKP0ou9rx4cJmRtaXjhtfU7dHGQAAF2IQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zvq7kBKdAg62bOC0OzH7IanF22UE2
	i7YrB9ktXp3ZyGZxeeElVoveBVfZLBa2LWGxuLxrDpvFqeuf2SwOrzjAZLHu5XQWi2MzljA6
	8Hgs+HyF3WN2w0UWj1erZ7J63Lm2h83j/IyFjB5XTjSxevRtWcXo8fOljsfnTXIBnFFcNimp
	OZllqUX6dglcGV0f3zMVXOSvmPJoAmsD4yqeLkZODgkBE4k9rZMZIWwxiQv31rN1MXJxCAks
	Y5RY/O4oO0zRgl/drBCJ6YwSm/euYIdwfjFKzF32jhmkik1ATeLLl8NACQ4OEYFgiX/n/UFq
	mAWamCXuzdnOClIjJNDIKPGuRwjE5hRwk1hz7j8LiC0sEC5x6OJRZpBeFgFViU+HlEDCvAK2
	Eifu3WaHsAUlfky+B1bOLKAlsX7ncSYIW15i85q3YK0SAuoSj/7qgoRFBIwkLs+cB1UuIrHv
	xTtGkHMkBLZwSGzZsxvsZBYBAYlvkw+xQPTKSmw6wAzxr6TEwRU3WCYwSsxCsnkWks2zkGye
	hWTFAkaWVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxghSaFvB+PNA9aHGJOB1k9klhJNzgcm
	lbySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MFqu
	sGZruuxWqH6y5ernP2d25jiLWd29uWXi0ovnJz/9Jm+TW/0q9kDOBWVOgZ9nCgVVIibO9P43
	X+noEvYXb5bPMHYvqVxiK/T4QN3ZxT4qhryfla6eK1MT2Pe+aMtPkcl/n9zUufhy/ebsz4n2
	ZtFmdwpPe961nXQ+d8rKV2u/+HsYp3LFWD1XYinOSDTUYi4qTgQA+SXskCADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t9jQV3JCU6BBrvmMFscmP2Q1eLssoNs
	Fm1XDrJbvDqzkc3i8sJLrBa9C66yWSxsW8JicXnXHDaLU9c/s1kcXnGAyWLdy+ksFsdmLGF0
	4PFY8PkKu8fshossHq9Wz2T1uHNtD5vH+RkLGT2unGhi9ejbsorR4+dLHY/Pm+QCOKMaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5WUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZ0fXzPVHCRv2LKowmsDYyreLoYOTkk
	BEwkFvzqZoWwxSQu3FvP1sXIxSEkMJ1RYvPeFewQzi9GibnL3jGDVLEJqEl8+XIYKMHBISIQ
	LPHvvD9IDbNAE7PEvTnbwSYJCTQySrzrEQKxOQXcJNac+88CYgsLhEscuniUGaSXRUBV4tMh
	JZAwr4CtxIl7t9khbEGJH5PvgZUzC2hJrN95nAnClpfYvOYtWKuEgLrEo7+6IGERASOJyzPn
	QZWLSOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CE45z6R2MK5ssDjEKMDBqMTDe6DfIVCINbGsuDL3EKMEB7OSCK+nl2OgEG9KYmVValF+fFFp
	TmrxIcZkoD8nMkuJJucD02FeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KL
	YLYwcXBKNTA2rzwjNHnzkc0r+kOehDFL3/xsuV565f7AK8f8XY//f8ZwUizW4Zls7RGxxONB
	mgZKOw/ZL932sZfhTQT7j4ANH9pXxf7ksX/4IUEhMepAhMtCm+da5047v1Jy2LtyR4jmSk9V
	kZaI23x5shpCDncXX1Ja5M5xOfTzCkPDotV/j/1PPrc49s1MJZbijERDLeai4kQAqhOIRH0D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 15, 2013 8:01 AM, Doug Anderson wrote:
> 
> The exynox4210-ehci and exynos4210-ohci nodes need a clock specified
> using the common clock framework.  Document it.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

It looks good.
Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han

> ---
> Changes in v2:
> - Fixed embarrassing typo adc=>usb.  Thanks Jingoo!
> 
>  Documentation/devicetree/bindings/usb/exynos-usb.txt | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> index f66fcdd..b3abde7 100644
> --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
> @@ -10,6 +10,8 @@ Required properties:
>   - reg: physical base address of the controller and length of memory mapped
>     region.
>   - interrupts: interrupt number to the cpu.
> + - clocks: from common clock binding: handle to usb clock.
> + - clock-names: from common clock binding: Shall be "usbhost".
> 
>  Optional properties:
>   - samsung,vbus-gpio:  if present, specifies the GPIO that
> @@ -22,6 +24,9 @@ Example:
>  		reg = <0x12110000 0x100>;
>  		interrupts = <0 71 0>;
>  		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
> +
> +		clocks = <&clock 285>;
> +		clock-names = "usbhost";
>  	};
> 
>  OHCI
> @@ -31,10 +36,15 @@ Required properties:
>   - reg: physical base address of the controller and length of memory mapped
>     region.
>   - interrupts: interrupt number to the cpu.
> + - clocks: from common clock binding: handle to usb clock.
> + - clock-names: from common clock binding: Shall be "usbhost".
> 
>  Example:
>  	usb@12120000 {
>  		compatible = "samsung,exynos4210-ohci";
>  		reg = <0x12120000 0x100>;
>  		interrupts = <0 71 0>;
> +
> +		clocks = <&clock 285>;
> +		clock-names = "usbhost";
>  	};
> --
> 1.8.1.3

