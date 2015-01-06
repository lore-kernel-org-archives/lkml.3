Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbbAFIs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:48:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbbAFIs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:48:56 -0500
Message-ID: <54ABA174.70204@suse.cz>
Date: Tue, 06 Jan 2015 09:48:52 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christoph Jaeger <cj@linux.com>, Paul Bolle <pebolle@tiscali.nl>
CC: yann.morin.1998@free.fr, akpm@linux-foundation.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dborkman@redhat.com
Subject: Re: [PATCH] kconfig: use bool instead of boolean for type definition
 attributes
References: <1419108071-11607-1-git-send-email-cj@linux.com> <20150105194305.GB1513@betelgeuse.hsd1.ma.comcast.net> <1420499197.14308.45.camel@x220> <20150106004713.GD1513@betelgeuse.hsd1.ma.comcast.net> <20150106011131.GE1513@betelgeuse.hsd1.ma.comcast.net>
In-Reply-To: <20150106011131.GE1513@betelgeuse.hsd1.ma.comcast.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-06 02:11, Christoph Jaeger wrote:
> On Mon, Jan 05, 2015 at 07:47:13PM -0500, Christoph Jaeger wrote:
>> On Tue, Jan 06, 2015 at 12:06:37AM +0100, Paul Bolle wrote:
>>> On Mon, 2015-01-05 at 14:43 -0500, Christoph Jaeger wrote:
>>>> (adding Michal Marek)
>>>
>>> Yann added no commits in 2014. And I actually think Yann reacted to
>>> almost no patches last year. Perhaps none at all. What's going on?
>>
>> Dunno, but at least Michal seems to be up and running.
> 
> According to Michal, Yann was about to take over maintainership, but
> apparently he disappeared.

People are free to change their interests or priorities :-).

I'll merge your patch and try to keep an eye on other kconfig patches
posted to the mailing lists.

Michal
