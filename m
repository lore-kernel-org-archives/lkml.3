Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaCRLez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:34:55 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:37244 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaCRLey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <53177187.3040009@archlinux.org>
References: <1394020752-6186-1-git-send-email-thomas@archlinux.org>
 <7E804DF3-E191-427E-8E20-FE6ECDC490EA@holtmann.org> <CA+5PVA56oO6FS2pG+D7yJtNrTqBGZ1CtPygjid4E0f3cPPi83g@mail.gmail.com>
 <424A74F3-7646-449C-9F72-A0F4E9A28551@holtmann.org> <53177187.3040009@archlinux.org>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 18 Mar 2014 08:34:33 -0300
Message-ID: <CAKi4VA+W7BfhGDUTT0tgroO-YPAztAXy-K-b3jiC3BiNwwba8Q@mail.gmail.com>
Subject: Re: [PATCH] Revert "Bluetooth: Use devname:vhci module alias for
 virtual HCI driver"
To: =?UTF-8?Q?Thomas_B=C3=A4chler?= <thomas@archlinux.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas

On Wed, Mar 5, 2014 at 3:48 PM, Thomas Bächler <thomas@archlinux.org> wrote:
> Am 05.03.2014 19:36, schrieb Marcel Holtmann:
>>>>> This reverts commit bfacbb9aec029b3200053d84c8cd5d7575f2d4a5.
>>>>
>>>> NAK. We allocated a static minor for this.
>>>
>>> Johan mentioned that.  Commit b075dd40c95d11c2c8690f6c4d6232fc,
>>> correct?
>
> I am sorry Marcel, I only looked at the Linus tree, not at bluetooth or
> bluetooth-next. This commit should indeed fix the problem. Disregard my
> patch.
>
>>  Why isn't that headed into 3.14 right now, and CC'd to
>>> stable?  Currently you have a somewhat broken driver in 3.13 and
>>> 3.14-rcX that seems to have a pretty clear fix.
>>
>> somewhat broken? kmod prints this as an error, but it is not a regression in user functionality. The driver works just as before. The error message can be ignored.
>
> It's a regression in my sanity, since numerous users blame all kernel
> bugs on this error message and I am tired of explaining the situation
> (problem + error message == problem found *sigh*). I only sent this
> patch since I hadn't found the correct fix.

Feel free to CC kmod mailing list in these cases
(linux-modules@vger.kernel.org). We've added this message to kmod
exactly to catch problems like this and help people doing the drivers.
Once I found out the problem with vhci I sent the patch to fix it,
which is heading to Linus tree.

-- 
Lucas De Marchi
