Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaFJMRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:17:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaFJMQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:16:58 -0400
Message-ID: <5396F736.4080901@suse.cz>
Date: Tue, 10 Jun 2014 14:16:54 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Warren Turkal <wt@penguintechs.org>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-doc@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: possible typo
References: <539548E7.9070908@penguintechs.org> <20140609074630.GA15826@ravnborg.org> <53956B28.7040404@penguintechs.org>
In-Reply-To: <53956B28.7040404@penguintechs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-09 10:07, Warren Turkal wrote:
> commit 4ce2f36b4b06b7df569b1875c7ab834270786882
> Author: Warren Turkal <wt@penguintechs.org>
> Date:   Sun Jun 8 22:19:29 2014 -0700
> 
>      Fix a typo.
> 
>      Signed-off-by: Warren Turkal <wt@penguintechs.org>

Thanks, I applied the patch to kbuild.git#misc. But please write a more
meaningful subject line next time (I changed it to "kbuild: Fix a typo
in documentation") and use git format-patch to generate the patch, so
that the recipient can pipe your email git git am.

Michal
