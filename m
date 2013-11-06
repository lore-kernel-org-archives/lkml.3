Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab3KFBJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:09:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23470 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3KFBJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:09:51 -0500
Date: Wed, 06 Nov 2013 10:09:47 +0900
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v3 2/3] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
In-reply-to: <1383668001-19141-3-git-send-email-k.debski@samsung.com>
To: "'Kamil Debski'" <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org, kyungmin.park@samsung.com, kishon@ti.com,
        t.figa@samsung.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, galak@codeaurora.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Message-id: <000d01ceda8c$e31a6ec0$a94f4c40$%han@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7bit
Thread-index: Ac7aQkRdXihUhl4kSruIRKaQVav5+gASgWmg
DLP-Filter: Pass
X-AuditID: cbfee68e-b7f416d0000020d6-1f-527996dcd907
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t8zI9070yqDDHY+lbVYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBY/Xl9gs7jwtIfN4mzTG3aLaTv/s1pc3jWHzWLG+X1MFouWtTJb
	rD1yl93ibP9tNovzWzqZLA6/aWe1WD/jNYtFx9mD7A5CHpf7epk8ds66y+7Rt2UVo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DK2PbqFWvBR76KW6cWsTYwNvJ0MXJySAiYSGz51sEEYYtJ
	XLi3nq2LkYtDSGAZo8S/gx/ZYIr+vzzHDJFYxCjxY/8BRgjnF6PEln13WUGq2ATUJL58OcwO
	YosIaEr8bDjEAlLELHCMWWL7svtAOziAOuolTs2UAKnhFHCVeP7pMlivsECKxNbVL1hAbBYB
	VYmZE+cxgti8ArYSMzs/QdmCEj8m3wOrYRbQkli/8zgThC0vsXnNW2aQ8RIC6hKP/upCnGAk
	8bVrETtEiYjEvhfvGCGeOcAh8eh7NMQqAYlvk0HOBGmVldh0gBmiRFLi4IobLBMYJWYhWTwL
	yeJZSBbPQrJhASPLKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQVNG3g/HmAetDjMlA6ycy
	S4km5wNTTV5JvKGxmZGFqYmpsZG5pRlpwkrivIseJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYBRpNa9XXvojfL+WXMIChx374kT/TO98nyO5YOO5vGNnOOb1ugXqewls6bBvDrVUOu6j
	8T9B03TpXfeNYVE/bkiLzGk5rlay95bt5adTcq5/vVHU+3dXojKPrvHaRN3o9w2Sx4t4NTf/
	TZ338KD2UWGthJrPHg/NLbSdzJgmsnNoVm+6sV/WTomlOCPRUIu5qDgRAMqS1B0rAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsVy+t9jAd070yqDDO5OkbBYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBY/Xl9gs7jwtIfN4mzTG3aLaTv/s1pc3jWHzWLG+X1MFouWtTJb
	rD1yl93ibP9tNovzWzqZLA6/aWe1WD/jNYtFx9mD7A5CHpf7epk8ds66y+7Rt2UVo8fxG9uZ
	PD5vkgtgjWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1
	y8wBOl9JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLHt1SvWgo98FbdO
	LWJtYGzk6WLk5JAQMJH4//IcM4QtJnHh3nq2LkYuDiGBRYwSP/YfYIRwfjFKbNl3lxWkik1A
	TeLLl8PsILaIgKbEz4ZDLCBFzALHmCW2L7vP1MXIAdRRL3FqpgRIDaeAq8TzT5fBeoUFUiS2
	rn7BAmKzCKhKzJw4jxHE5hWwlZjZ+QnKFpT4MfkeWA2zgJbE+p3HmSBseYnNa94yg4yXEFCX
	ePRXF+IEI4mvXYvYIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBKeiZ1I7GFc2WBxiFOBgVOLhTZCvDBJiTSwrrsw9xCjBwawkwqsUBxTi
	TUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGCazCuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQ
	QHpiSWp2ampBahHMFiYOTqkGxrawos31cUmaEotXRl0U6S6ftnrxiZmRj2wL2tfn9aovPZBY
	uNtFYa2ptlHwh0KWjTc/tXWeW/rhYEjwOxX/0vs7nS+tyzlgfeeY+6r5m/nfxNhoXV++oSw8
	Llr87uWf0yuafN/vEJuUtrxqokRJrWu/j+wlX44ZYTEvbvSub5ymUmX8Zu/UyUosxRmJhlrM
	RcWJABfJ6qWJAwAA
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com>
 <1383668001-19141-3-git-send-email-k.debski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 06, 2013 1:13 AM, Kamil Debski wrote:
> 
> Change the phy provider used from the old usb phy specific to a new one
> using the generic phy framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/host/ehci-exynos.c |   34 +++++++++++-----------------------
>  1 file changed, 11 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index 8898c01..974001b 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c

[.....]

> @@ -98,12 +98,12 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  	exynos_ehci = to_exynos_ehci(hcd);
> -
>  	if (of_device_is_compatible(pdev->dev.of_node,
>  					"samsung,exynos5440-ehci"))
>  		goto skip_phy;
> 
> -	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> +	phy_name = of_get_property(pdev->dev.of_node, "phy-names", NULL);
> +	phy =  devm_phy_get(&pdev->dev, phy_name);
>  	if (IS_ERR(phy)) {
>  		usb_put_hcd(hcd);
>  		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");

Hi Kamil,

The following build error happens.

drivers/usb/host/ehci-exynos.c: In function 'exynos_ehci_probe'
drivers/usb/host/ehci-exynos.c:113:14: error: 'struct exynos_ehci_hcd' has no member named 'otg'
drivers/usb/host/ehci-exynos.c:113:25: error: 'struct phy' has no member named 'otg'

Would you add the following to this patch?

--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -110,7 +110,6 @@ static int exynos_ehci_probe(struct platform_device *pdev)
                return -EPROBE_DEFER;
        } else {
                exynos_ehci->phy = phy;
-               exynos_ehci->otg = phy->otg;
        }

Best regards,
Jingoo Han

