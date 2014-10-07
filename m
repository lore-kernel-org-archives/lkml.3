Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaJGGNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 02:13:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48392 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaJGGNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 02:13:38 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-63-5433848dd2bc
Content-transfer-encoding: 8BIT
Message-id: <54338484.5070809@samsung.com>
Date: Tue, 07 Oct 2014 08:13:24 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
To: Mark yao <mark.yao@rock-chips.com>, heiko@sntech.de,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org,
        dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org,
        olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com,
        kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com,
        zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com,
        kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com
Subject: Re: [PATCH v9 1/3] drm: rockchip: Add basic drm driver
References: <1412081870-27535-1-git-send-email-mark.yao@rock-chips.com>
 <1412082181-27703-1-git-send-email-mark.yao@rock-chips.com>
 <542AB0B2.6000207@samsung.com> <54336474.1010503@rock-chips.com>
In-reply-to: <54336474.1010503@rock-chips.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0zMcRjHfb6f733uSjdfp/TRH9puZK5fhO2JFvNjfc0/smZm8+PoJuoq
	d4oYLlFXlpImDnVHdSFru2spolxRikgltUosK/1e1EUqXf3Bf++9n9fzft5/PCIsSRK4iI6G
	n1CowuVhUmLP1k5VNXomX1wTtEpTIYXq5rsMlPcYWLik7SWQnVKLYLroKoaOrFIhZFXWCeBt
	7gsCsTeyBNA4OkQgpd8ggPI/xQji7hUQmP7aJ4BCvRVDXe99BG8mPKEo4xeBuJQJBsxWLQFD
	fDYLDU9uExjpnMaQaZlAkNNcz0BxejkDNc0/CKRmPGJhoC2DhW7DOIZLzyqFMPzwuRAS4nIZ
	SNNLoLesB0NT4WcCUx2hkNVZjDe58fmZ+Yi/paln+YYryQz/bEzP8l2mesSX6NqFvN4Uxd83
	/iS8OU/Gmx4kEr7tYynhy+7kC/nPl6sY3px9nm+sviDgJ3Vl7E7JXnu/YEXY0WiFytv/oH1I
	euxLHGlyPjVmnEIaFLsoCdmJKLeWVpj72Dm9mL7vKCA2LeFyEL1zVWXTYm4hHb/WMcOIRJhz
	pZUfQm025lbQtMy7OAnZz+AjiNbWvCY2RszJaH+Vu41hueV04LIF2TThVtJJc8tsvBO3h75u
	LxXadh25byxN/90wG4S5NJaWDyViG7WI20if11mZuQvViD7VWmcHdpwXjX/1BaciTvdfQd2/
	grr/CuoRfoCcFFGHI9WHjih9vNRypToq/IjX4QilCc39z2gxynm13oI4EZI6iPNka4IkAnm0
	OkZpQVSEpY7iwlMzljhYHnNaoYo4oIoKU6gtiBHZuWjQKmaBs4NV6nvFqWvDcZfBJTeTQ8L7
	hoO7jZp9I9kBWr9P2rI9T5d67yJjg49XuyYua5iPPV6cbb3+ztvn/TomUntGGTivcyow2nB9
	s9F/S8G5mF2+Na59Tc4n/Ur2BwWkRsZVOR/7XtSzo2L71haPnS1BvW7uAQdamYcXmd39CdsW
	uEhZdYh8tQyr1PK/uk+tKR0DAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 05:56 AM, Mark yao wrote:
> On 2014年09月30日 21:31, Andrzej Hajda wrote:
>> Hi Mark,
> Hi Andrzej,
>     Sorry for replying late, I have a vacation before.
>     Thanks for your review.
>> On 09/30/2014 03:03 PM, Mark Yao wrote:
>>> From: Mark yao <mark.yao@rock-chips.com>
>>>
(...)
>>> +#ifdef CONFIG_PM_SLEEP
>>> +static int rockchip_drm_suspend(struct drm_device *dev, pm_message_t state)
>>> +{
>>> +	struct drm_connector *connector;
>>> +
>>> +	drm_modeset_lock_all(dev);
>>> +	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
>>> +		int old_dpms = connector->dpms;
>>> +
>>> +		if (connector->funcs->dpms)
>>> +			connector->funcs->dpms(connector, DRM_MODE_DPMS_OFF);
>>> +
>>> +		/* Set the old mode back to the connector for resume */
>>> +		connector->dpms = old_dpms;
>>> +	}
>>> +	drm_modeset_unlock_all(dev);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int rockchip_drm_resume(struct drm_device *dev)
>>> +{
>>> +	struct drm_connector *connector;
>>> +
>>> +	drm_modeset_lock_all(dev);
>>> +	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
>>> +		if (connector->funcs->dpms)
>>> +			connector->funcs->dpms(connector, connector->dpms);
>>> +	}
>>> +	drm_modeset_unlock_all(dev);
>>> +
>>> +	drm_helper_resume_force_mode(dev);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int rockchip_drm_sys_suspend(struct device *dev)
>>> +{
>>> +	struct drm_device *drm_dev = dev_get_drvdata(dev);
>>> +	pm_message_t message;
>>> +
>>> +	if (pm_runtime_suspended(dev))
>>> +		return 0;
>>> +
>>> +	message.event = PM_EVENT_SUSPEND;
>>> +
>>> +	return rockchip_drm_suspend(drm_dev, message);
>> drm_dev can be NULL here, it can happen when system is suspended
>> before all components are bound. It can also contain invalid pointer
>> if after successfull drm initialization de-initialization happens for
>> some reason.
>>
>> Some workaround is to check for null here and set drvdata to null on
>> master unbind. But I guess it should be protected somehow to avoid races
>> in accessing drvdata.
> So, can I use the way that check for null here and set drvdata to null
> on master unbind?
> I don't know which way is better to protect somehow.

It seems to be a core problem, I have proposed some solution using drm
driver PM callbacks [1]
but it appears these callbacks are obsolete, so different solution
should be found. According to
Russel probably some extension of component framework.
As a temporary solution I guess null checks should work in most cases.

Regards
Andrzej


[1]: https://lkml.org/lkml/2014/10/3/60

>
> -Mark.
>>> +}
>>> +
>>> +static int rockchip_drm_sys_resume(struct device *dev)
>>> +{
>>> +	struct drm_device *drm_dev = dev_get_drvdata(dev);
>>> +
>>> +	if (!pm_runtime_suspended(dev))
>>> +		return 0;
>>> +
>>> +	return rockchip_drm_resume(drm_dev);
>> Ditto.
>>
>> Regards
>> Andrzej
>>
>>

