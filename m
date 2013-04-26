Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3DZPDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:03:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3DZPDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:03:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
Date: Fri, 26 Apr 2013 17:03:17 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linaro-kernel@lists.linaro.org, Peter Maydell <peter.maydell@linaro.org>,
        patches@linaro.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <1577576.O1Cm2pf5KD@wuerfel> <CALrVBkuyby_KY_M+yp0e=PLk=7_W_kSxxm62YYSwwp8rwLsCAQ@mail.gmail.com>
In-Reply-To: <CALrVBkuyby_KY_M+yp0e=PLk=7_W_kSxxm62YYSwwp8rwLsCAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304261703.17798.arnd@arndb.de>
X-Provags-ID: V02:K0:KE8Q/4a+qj5rQUDaF5/4WPSZagObv0TiACAZ+pyi2zi
 4/8cnPozYINq5lBzaOdn8ITz52A4KxbH6OLxyQewPRxeP9i8pw
 0uLEoFMHvEMaMymh545ZAHXgB7viVf4ZgaS4nHVWHlX2ov4myy
 WzBNUl/bGAnWouP7ZNdUdfLbjeeJVxPQApr0GR21Lm21GSvlEI
 EsJZYBwBgX4Ok3b1XRQFXEEqkj7OmlC+7MkGlzCPxZ/qj/FiQt
 0yzBuGm6uXNIeqeKZB/ik+aZPm13gv7IJjW45E65eWG0tWjhv6
 IOrMqQptsHC72Bi5R7FrqFQ5R8Hw5Qwp+lkBxqh2tpBP//CmV9
 7x4xHiRva1co/cOk3aRs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013, Anup Patel wrote:
> I am curious about how smh-based or hypercall-based early prints would
> be handled in following scenario:
> 
> "A board is running KVM ARM enabled kernel and linux console on serial
> port. Now a user remotely connects to the board via telnet/ssh and
> launches a VM with smh-based or hypercall-based earlyprintk."
> 
> In the above scenario, will smh-based or hypercall-based earlyprints
> appear to user on remote shell or not ?

The implementation of the console device would still be done by KVM,
as for any other virtual device, so it shows up whereever kvm is
configured to output the console data.

	Arnd
