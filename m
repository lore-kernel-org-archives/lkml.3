Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaJ3En4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:43:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47030 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaJ3Eny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:43:54 -0400
X-AuditID: cbfee691-f79b86d000004a5a-45-5451c20934fd
From: Jingoo Han <jg1.han@samsung.com>
To: "=?ISO-8859-1?Q?'Heiko_St=FCbner'?=" <heiko@sntech.de>
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <50522512.UJWUZtqLop@diego>
In-reply-to: <50522512.UJWUZtqLop@diego>
Subject: Re: [PATCH] backlight: use of_find_backlight_by_node stub when
 backlight class disabled
Date: Thu, 30 Oct 2014 13:44:16 +0900
Message-id: <000501cff3fc$2946aec0$7bd40c40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/zDaXelY3R0wRnSjCTkjfT3TVOrgA7hvlQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zY13OQ4EhBq+3CVkc3TmRyeL/o9es
	FpcXXmK1uP/1KKPF5V1z2BxYPXbOusvucefaHjaPvi2rGD22X5vH7PF5k1wAaxSXTUpqTmZZ
	apG+XQJXxpSl3WwFu7kq/t0/zNTAeIGji5GTQ0LARGLS/4nsELaYxIV769m6GLk4hASWMUpc
	mbOTBaboycM5UInpjBLPHryAcn4xSnyb2M8MUsUmoCbx5cthsFEiAhYS92esB4szC3QzSty4
	EdbFyAHUoC4x9XkVSJhTQENi9qdJjCC2sECSxNVTt1lBbBYBVYnj/RPYQGxeAVuJPQ83M0HY
	ghI/Jt9jgRipI7G/dRobhK0t8eTdBVaQ8RJA4x/91YW4wEiieeINVogSEYl9L94xQvxyjV1i
	5k95iFUCEt8mH2KBaJWV2HSAGaJEUuLgihssExglZiFZPAvJ4llIFs9CsmEBI8sqRtHUguSC
	4qT0IlO94sTc4tK8dL3k/NxNjJA4nbiD8f4B60OMAhyMSjy8L5IDQoRYE8uKK3MPMZoCXTSR
	WUo0OR+YDPJK4g2NzYwsTE1MjY3MLc2UxHl1pH8GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amCUzwsL7Lyn8YSrLt9+H3PDze3qTunLMqYV7Em+IfL/jJK7pYtg34rG8v3PPz9tllKfrXHn
	nZWt8PoZ/B9faLgo6Mje33qlUmVNzrrGs3FnuC463bA+M8d4inVhsDePZPv6OAt/XbuaYu3a
	zslMu1+v0mR5uPvN9BArnf8s+U9Ce+bd65cVPKbEUpyRaKjFXFScCAA9cWwWzgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xoC7nocAQg7d7+SyO7pzIZPH/0WtW
	i8sLL7Fa3P96lNHi8q45bA6sHjtn3WX3uHNtD5tH35ZVjB7br81j9vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPK0m62gt1cFf/uH2ZqYLzA0cXIySEhYCLx
	5OEcNghbTOLCvfVANheHkMB0RolnD15AOb8YJb5N7GcGqWITUJP48uUwO4gtImAhcX/GerA4
	s0A3o8SNG2FdjBxADeoSU59XgYQ5BTQkZn+axAhiCwskSVw9dZsVxGYRUJU43j8BbDGvgK3E
	noebmSBsQYkfk++xQIzUkdjfOo0NwtaWePLuAivIeAmg8Y/+6kJcYCTRPPEGK0SJiMS+F+8Y
	JzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOA08Ex6B+Oq
	BotDjAIcjEo8vC+SA0KEWBPLiitzDzFKcDArifCKdASGCPGmJFZWpRblxxeV5qQWH2I0BXp0
	IrOUaHI+MEXllcQbGpuYGVkamVkYmZibK4nzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpg1NrM
	zPG38NO3xc9qtX9PUXrixLCuYt/aI3fOZqUWzTeIFVwZfGvhBpuFC1g1bY7Vh9VOyts71Tab
	tc1nWVBTlcqZmhmWJj2x7zXfvt0kdkxrU9j+0n0vD79Y/abW6OV6BvlvYcvdbSy5uHUSQuPu
	h88Qu3PI4+2GLPXAzuuP/JvVHZRlGYOvK7EUZyQaajEXFScCAAFOXPcZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 29, 2014 9:20 AM, Heiko Stübner wrote:
> 
> Drivers may want to search for an optional backlight even when the backlight
> class is disabled. In this case the linker would miss the function referenced
> in the backlight header.
> 
> Therefore use the stub function also when the backlight class is disabled.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

of_find_backlight_by_node()is defined at ./drivers/video/backlight/backlight.c
file. Also, this file can be built when CONFIG_BACKLIGHT_CLASS_DEVICE=y.
So, in order to prevent the possible build error, this patch looks good.

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  include/linux/backlight.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index adb14a8..d9cb644 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -157,7 +157,7 @@ struct generic_bl_info {
>  	void (*kick_battery)(void);
>  };
> 
> -#ifdef CONFIG_OF
> +#if defined(CONFIG_OF) && defined(CONFIG_BACKLIGHT_CLASS_DEVICE)
>  struct backlight_device *of_find_backlight_by_node(struct device_node *node);
>  #else
>  static inline struct backlight_device *
> --
> 2.0.1


