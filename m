Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbbAFToQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:44:16 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44059 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbbAFToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:44:04 -0500
Date: Tue, 6 Jan 2015 11:43:54 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: "jeffrey.lin" <yajohn@gmail.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, shc_work@mail.ru,
        charliemooney@chromium.org, bleung@chromium.org, lee.jones@linaro.org,
        jeffrey.lin@rad-ic.com, roger.yang@rad-ic.com, KP.li@rad-ic.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] driver: input :touchscreen : add Raydium I2C touch driver
Message-ID: <20150106194354.GA12576@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	"jeffrey.lin" <yajohn@gmail.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, shc_work@mail.ru, charliemooney@chromium.org,
	bleung@chromium.org, lee.jones@linaro.org, jeffrey.lin@rad-ic.com,
	roger.yang@rad-ic.com, KP.li@rad-ic.com,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <1420536350-5916-1-git-send-email-jeffrey.lin@rad-ic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420536350-5916-1-git-send-email-jeffrey.lin@rad-ic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:25:50PM +0800, jeffrey.lin wrote:
> From: "jeffrey.lin" <jeffrey.lin@rad-ic.com>
> 
> This patch is porting Raydium I2C touch driver. Developer can enable
>  raydium touch driver by modifying define "CONFIG_TOUCHSCREEN_RM_TS".
> 
> Signed-off-by: jeffrey.lin@rad-ic.com

You need your full legal name in your Signed-off-by:

-- 
- Jeremiah Mahler
