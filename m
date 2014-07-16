Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaGPK3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:29:44 -0400
Received: from sym2.noone.org ([178.63.92.236]:36954 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaGPK3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:29:42 -0400
Date: Wed, 16 Jul 2014 12:29:36 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Kamil Debski <k.debski@samsung.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, t.figa@samsung.com,
        m.szyprowski@samsung.com, linux@roeck-us.net,
        linux-pwm@vger.kernel.org, varkabhadram@gmail.com
Subject: Re: [PATCH v4] hwmon: pwm-fan: Add pwm-fan driver
Message-ID: <20140716102935.GA24362@distanz.ch>
References: <1405505014-24983-1-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405505014-24983-1-git-send-email-k.debski@samsung.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-16 at 12:03:34 +0200, Kamil Debski <k.debski@samsung.com> wrote:
> The pwm-fan driver enables control of fans connected to PWM lines.
> This driver uses the PWM framework, so it is compatible with all
> PWM devices that provide drivers through the PWM framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>

Looks good as for my comments. If you want you can add my

Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
