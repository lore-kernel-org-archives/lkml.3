Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbbAUQdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:33:16 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36631 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbAUQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:33:08 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-f4-54bfd42ffe82
Message-id: <54BFD4B9.8030707@samsung.com>
Date: Wed, 21 Jan 2015 17:32:57 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>, linux-kernel@vger.kernel.org
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH/RFC v10 17/19] DT: Add documentation for exynos4-is
 'flashes' property
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-18-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1420816989-1808-18-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e/4ZV39K/tDDBo32FhsnLGe1eLozolM
	FvOPnGO16H+zkNXi3KuVjBa9V58zWpxtesNucXnXHDaLrW/WMVr0bNjKarH0+kUmi7unjrJZ
	TJi+lsWide8Rdovdu56yWpzZv5LNQcBjzbw1jB6X+3qZPHbOusvusXL5FzaPw18XsnhsWtXJ
	5rFn/g9Wj74tqxg9Vqz+zu7xeZNcAFcUl01Kak5mWWqRvl0CV8bR57cZCx7zVPS3/WVuYNzG
	1cXIySEhYCJx89EuJghbTOLCvfVsXYxcHEICSxklGs6eYIZwPjFKHF3+jKWLkYODV0BLYtk+
	ZpAGFgFViU1/9rKC2GwChhK9R/sYQWxRgQiJk3f3sIPYvAKCEj8m32MBsUUEfCUe3LjOAjKT
	WWAms8SjwzsYQWYKC8RILH7mArGrjVFi3u8pYA2cAp4Slxe8YAepYRbQk7h/UQskzCwgL7F5
	zVvmCYwCs5CsmIVQNQtJ1QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIfH2ZQfj4mNW
	hxgFOBiVeHgrQveHCLEmlhVX5h5ilOBgVhLh9TsIFOJNSaysSi3Kjy8qzUktPsTIxMEp1cAY
	la0nO683bZ7Kj18XjsuoWb3M+MW9SYj/wf7DesvXb7v5JfVsx+NHS7UC1Ocwzb0j6rm4bNr/
	29V3Nzfz/jklct6mVCUh822MakDiJMYFnCLuWzYxnXd6u/YYR+zi9as+Wx7ONkpsmO/0cod8
	satF9DkdptmTrVdL/TZk2Rnls1VY/MK2vEuvlViKMxINtZiLihMBZNE0mZUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/01/15 16:23, Jacek Anaszewski wrote:
> This patch adds a description of 'flashes' property
> to the samsung-fimc.txt.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

> ---
>  .../devicetree/bindings/media/samsung-fimc.txt     |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> index 922d6f8..22a6b2f 100644
> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> @@ -40,6 +40,12 @@ should be inactive. For the "active-a" state the camera port A must be activated
>  and the port B deactivated and for the state "active-b" it should be the other
>  way around.
>  
> +Optional properties:
> +
> +- flashes - Array of phandles to flash LED devices, or their sub-nodes
> +	    representing sub-leds.
> +	    (see Documentation/devicetree/bindings/leds/common.txt)

How about renaming this to "illuminators" or something else more generic?
The "torch" LED (for video recording illumination?) is not really a flash.

> +
>  The 'camera' node must include at least one 'fimc' child node.
>  
>  
> @@ -166,6 +172,7 @@ Example:
>  		clock-output-names = "cam_a_clkout", "cam_b_clkout";
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&cam_port_a_clk_active>;
> +		flashes = <&camera_flash>, <&system_torch>;
>  		status = "okay";
>  		#address-cells = <1>;
>  		#size-cells = <1>;
--
Thanks,
Sylwester
