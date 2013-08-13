Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab3HMNSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:18:34 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61529 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab3HMNSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:18:32 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <520A2C52.3000804@citrix.com>
References: <1376316812-30346-1-git-send-email-lccycc123@gmail.com>
 <1376339161.15390.281.camel@Solace> <520A2C52.3000804@citrix.com>
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Date: Tue, 13 Aug 2013 09:18:11 -0400
X-Google-Sender-Auth: WtG2xOI6QCydvu7eM8yaOqZNijU
Message-ID: <CAPbh3ru-gq0oL-MFbXmWDWOLwXVqZSbKUSJbotBJVy7OLYgKbw@mail.gmail.com>
Subject: Re: [PATCH v1][RFC] drivers/xen, balloon driver numa support in kernel
To: David Vrabel <david.vrabel@citrix.com>
Cc: Dario Faggioli <dario.faggioli@citrix.com>,
        Yechen Li <lccycc123@gmail.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 8:53 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> On 12/08/13 21:26, Dario Faggioli wrote:
>>
>> Mmm... Is that the case? I tried to apply it there and I have one failed
>> hunk (#12). Anyway, could you please rebase it on the tip of some
>> relevant git tree?
>>
>> Linus' tree would be fine, I guess:
>>
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git
>
> This is the one I use for most of my development work.  I wouldn't use a
> subsystem specific tree unless there were specific conflicts to resolve
> before hand.

Which we do:

commit cd9151e26d31048b2b5e00fd02e110e07d2200c9
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Sun Aug 4 15:39:40 2013 +0100
    xen/balloon: set a mapping for ballooned out pages

>
> David
