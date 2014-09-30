Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaI3IKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:10:33 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47325 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaI3IK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:10:26 -0400
Date: Tue, 30 Sep 2014 10:10:20 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Mark Yao <mark.yao@rock-chips.com>
Cc: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net,
        djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
        cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com
Subject: Re: [PATCH v8 2/3] dt-bindings: video: Add for rockchip display
 subsytem
Message-ID: <20140930081020.GE24667@phenom.ffwll.local>
Mail-Followup-To: Mark Yao <mark.yao@rock-chips.com>, heiko@sntech.de,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
	Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Grant Likely <grant.likely@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Stultz <john.stultz@linaro.org>,
	Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
	linux-rockchip@lists.infradead.org, dianders@chromium.org,
	marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net,
	djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
	cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
	xxm@rock-chips.com, huangtao@rock-chips.com,
	kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
	xw@rock-chips.com
References: <1412057386-19375-1-git-send-email-mark.yao@rock-chips.com>
 <1412057659-19483-1-git-send-email-mark.yao@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412057659-19483-1-git-send-email-mark.yao@rock-chips.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 02:14:19PM +0800, Mark Yao wrote:
> From: Mark yao <mark.yao@rock-chips.com>
> 
> This add a display subsystem comprise the all display interface nodes.
> 
> Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Acked-by: Daniel Vetter <daniel@ffwll.ch>
> Reviewed-by: Rob Clark <robdclark@gmail.com>

Just a quick clarification: My ack was only about the drm driver itself, I
try really hard to stay away from DT insanity ;-) So please drop my ack
from these two patches.

Aside: DT patches need to go through a special process and you must cc dt
maintainers and mailing lists. Your patch seems to lack this, which afaiui
is a blocker for merging the driver.

Thanks, Daniel

> ---
> Changes in v2:
> - add DRM master device node to list all display nodes that comprise
>   the graphics subsystem.
> 
> Changes in v3: None
> 
> Changes in v4: None
> 
> Changes in v5: None
> 
> Changes in v6: None
> 
> Changes in v7: None
> 
> Changes in v8: None
> 
>  .../devicetree/bindings/video/rockchip-drm.txt     |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/rockchip-drm.txt
> 
> diff --git a/Documentation/devicetree/bindings/video/rockchip-drm.txt b/Documentation/devicetree/bindings/video/rockchip-drm.txt
> new file mode 100644
> index 0000000..7fff582
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/rockchip-drm.txt
> @@ -0,0 +1,19 @@
> +Rockchip DRM master device
> +================================
> +
> +The Rockchip DRM master device is a virtual device needed to list all
> +vop devices or other display interface nodes that comprise the
> +graphics subsystem.
> +
> +Required properties:
> +- compatible: Should be "rockchip,display-subsystem"
> +- ports: Should contain a list of phandles pointing to display interface port
> +  of vop devices. vop definitions as defined in
> +  Documentation/devicetree/bindings/video/rockchip-vop.txt
> +
> +example:
> +
> +display-subsystem {
> +	compatible = "rockchip,display-subsystem";
> +	ports = <&vopl_out>, <&vopb_out>;
> +};
> -- 
> 1.7.9.5
> 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
