Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaIBLRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:17:35 -0400
Received: from vegas.theobroma-systems.com ([144.76.126.164]:54437 "EHLO
	mail.theobroma-systems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbaIBLRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:17:33 -0400
X-Greylist: delayed 978 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2014 07:17:33 EDT
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] Input: cap1106 - fix register definition
From: Klaus Goger <klaus.goger@theobroma-systems.com>
In-Reply-To: <54057526.9050503@gmail.com>
Date: Tue, 2 Sep 2014 13:01:11 +0200
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <53EB1EFA-3BFF-4818-A524-B3ED3CF62D56@theobroma-systems.com>
References: <1409639544-30420-1-git-send-email-klaus.goger@theobroma-systems.com> <54057526.9050503@gmail.com>
To: Daniel Mack <zonque@gmail.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 2, 2014, at 9:43 AM, Daniel Mack <zonque@gmail.com> wrote:
> On 09/02/2014 08:32 AM, Klaus Goger wrote:
>> Use the correct register address for Calibration Active and Interrupt
>> Enable
>> 
>> Signed-off-by: Klaus Goger <klaus.goger@theobroma-systems.com>
> 
> These register definitions are currently unused, but your fix is
> correct. Just curious - are you planning to send patches that make use
> of them?

I want to use CAP1106_REG_SENSITIVITY_CONTROL but I have yet to
decide how to expose it to the user. Probably adding another device tree
option. But somehow it feels like cluttering up the dts.
Once I have settled about that I will send patches.
