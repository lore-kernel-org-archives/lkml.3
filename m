Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966465AbaFRMd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:33:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966138AbaFRMdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:33:25 -0400
Message-ID: <53A18712.6030907@suse.cz>
Date: Wed, 18 Jun 2014 14:33:22 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: relative objtree change broke tar builds?
References: <20140617223854.GC6168@fieldses.org> <53A15684.9000002@suse.cz> <20140618122029.GA17790@fieldses.org>
In-Reply-To: <20140618122029.GA17790@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 18.6.2014 14:20, J. Bruce Fields napsal(a):
> On Wed, Jun 18, 2014 at 11:06:12AM +0200, Michal Marek wrote:
>> Dne 18.6.2014 00:38, J. Bruce Fields napsal(a):
>>> The changelog there says
>>>
>>> 	The main Makefile sets its working directory to the object tree
>>> 	and never changes it again. Therefore, we can use '.' instead of
>>> 	the absolute path.
>>>
>>> But the main Makefile also exports objtree, and a quick grep suggests
>>> lots of other uses outside the main Makefile.
>>
>> Do you have examples? Besides your report, I'm only aware of make
>> deb-pkg and make *docs. What else?
> 
> I haven't looked.
> 
> I only note that grep finds 47 files referencing that variable, and
> absent some argument that the remaining ones are correct, I'd be
> inclined to revert.

Do these 47 files change the working directory before referencing the
variable?

Thanks,
Michal

