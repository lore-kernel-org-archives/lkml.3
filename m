Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaJLQVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 12:21:49 -0400
Received: from orange.myspectrum.nl ([149.210.134.247]:59605 "EHLO
	orange.myspectrum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaJLQVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 12:21:43 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2014 12:21:43 EDT
Message-ID: <543AA8BF.7090809@myspectrum.nl>
Date: Sun, 12 Oct 2014 18:13:51 +0200
From: Jeroen Hofstee <jeroen@myspectrum.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>, u-boot@lists.denx.de
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [U-Boot] [PATCH resend] kconfig: Fix compiler warning in menu.c
References: <1413109527-10718-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1413109527-10718-1-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

On 12-10-14 12:25, Hans de Goede wrote:
> Hi,
>
> This one seems to have fallen through the cracks.
>
> Regards,
>
> Hans
>
(for U-boot)

nope, you replace an innocent warning (_might_ be) with
bad code, without any comment it is just because gcc failed
to recognize it is fine. Nor did you respond to the suggestion
if it helps gcc to recognize that if the two booleans are merged
into a single one. [or even split it in an if () if ()]. With this patch
you prevent any serious warning in case the variable is actually
used but not initialized, which is even worse if you ask me.

Regards,
Jeroen


