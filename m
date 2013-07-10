Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3GJO4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:56:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab3GJO4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:56:07 -0400
Message-ID: <51DD7601.5090200@suse.cz>
Date: Wed, 10 Jul 2013 16:56:01 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
Cc: Rob Landley <rob@landley.net>, Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] menuconfig: Allow j/k to move down/up the menu
References: <1373023979-20537-1-git-send-email-artagnon@gmail.com> <1373151605.27613.9@driftwood> <478d866c-606e-42de-9779-6ae18d70e7f1@CO1EHSMHS014.ehs.local>
In-Reply-To: <478d866c-606e-42de-9779-6ae18d70e7f1@CO1EHSMHS014.ehs.local>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 9.7.2013 01:08, Sören Brinkmann napsal(a):
> On Sat, Jul 06, 2013 at 06:00:05PM -0500, Rob Landley wrote:
>> On 07/05/2013 06:32:59 AM, Ramkumar Ramachandra wrote:
>>> Like in Vim.
>>>
>>> Cc: Michal Marek <mmarek@suse.cz>
>>> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
>>> ---
>>> Unsure why nobody has done this yet.
>>
>> While you're at it, why don't you add the ws up and down bindings
>> from World of Warcraft?
>>
[...]
> Well, one advantage of these key bindings is, that you don't have to
> move your hands away from the base line. And as vim user I find myself
> using vim key sequences in all tools.

One issue here is that j and k are already taken. Letters other than
h/m/n/y are used as hotkeys in menuconfig/nconf, if there is a menu item
starting with the respective letter. So at a minimum, the patch would
have to add j and k to the reserved set.

Michal
