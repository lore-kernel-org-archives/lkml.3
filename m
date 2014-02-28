Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaB1DCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:02:09 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57239 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaB1DCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:02:07 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <530FFC2C.5010305@roeck-us.net>
Date: Thu, 27 Feb 2014 19:02:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: Josh Boyer <jwboyer@fedoraproject.org>, Jiri Slaby <jslaby@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, David Miller <davem@davemloft.net>
Subject: Re: 3.12-stable kernel tree being taken over by Jiri Slaby
References: <20140226231910.GA8789@kroah.com>
In-Reply-To: <20140226231910.GA8789@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 03:19 PM, Greg Kroah-Hartman wrote:
> As I hinted at in my kernel summit talk about the stable kernel tree, we
> have a sucker^Wvolunteer who has stepped up to take over the longterm
> maintenance of the 3.12 stable kernel tree.
>
> Jiri Slaby will be doing this work, for how ever long he wants to do it.
> I'll still be doing the final releases to kernel.org, like I do for 3.2,
> but Jiri will be doing the collecting of patches and other real work
> involved in it, including the announcements for its release.
>

Jiri,

do you want me to keep running my build tests on the patch queue for 3.12 ?

If yes, I'll probably need to know the location of your (quilt ?) repository
so I can import the patches, similar to what I do for 3.2 and the releases
managed by Greg.

Thanks,
Guenter

