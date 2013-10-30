Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3J3GaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 02:30:06 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39619 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3J3GaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 02:30:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAEPRUYqnc0C_fEG97sFVs6uAtPyZCzXuJ09Hsb3unjAZtc5shA@mail.gmail.com>
References: <1380987809-4886-1-git-send-email-bcm@fixthebug.org>
	<CAEPRUYqnc0C_fEG97sFVs6uAtPyZCzXuJ09Hsb3unjAZtc5shA@mail.gmail.com>
Date: Tue, 29 Oct 2013 23:30:02 -0700
Message-ID: <CAEPRUYqV-9P6spmxGsqOS6JGbZW79L7m4SO66Jbkyq4Kam=bRQ@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: bcm: Add DEBUG_LL console support
From: Christian Daudt <bcm@fixthebug.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Chris Ball <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Christian Daudt <bcm@fixthebug.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:12 PM, Christian Daudt <bcm@fixthebug.org> wrote:
> On Sat, Oct 5, 2013 at 8:43 AM, Christian Daudt <bcm@fixthebug.org> wrote:
>> This patch adds low level debug uart support to Broadcom
>>  mobile based SOCs.
>>
>> Signed-off-by: Christian Daudt <bcm@fixthebug.org>
>>
>> Changes from V2:
>>  - Changed to follow hex ordering on entries
>>  - Dropped defconfig changes
>>
>> Changes from V1:
>>  - Switched to use the common 8250 debug introduced in 3.12-rc1
>>
>
> Hi Russell,
>  Does V3 look ok ?
>
>  Thanks,
>    csd
Hi,
 Can anyone provide an ack on this mod ?

 Thanks,
   csd
