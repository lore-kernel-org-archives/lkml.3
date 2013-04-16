Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3DPJMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:12:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab3DPJMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:12:43 -0400
Message-ID: <516D1609.6020500@suse.cz>
Date: Tue, 16 Apr 2013 11:12:41 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Benjamin Poirier <bpoirier@suse.de>, Wang YanQing <udknight@gmail.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] menuconfig: Fix memory leak introduced by jump keys
 feature
References: <1366035231-24370-1-git-send-email-bpoirier@suse.de> <20130415215432.GB12519@free.fr> <516D0A1B.1010704@suse.cz>
In-Reply-To: <516D0A1B.1010704@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.4.2013 10:21, Michal Marek wrote:
> On 15.4.2013 23:54, Yann E. MORIN wrote:
>> So, unless Michal really wants to pull this one and push it to Linus
>> before he cuts v3.9 final, I'll merge this later in my -for-next branch.
> 
> That's fine with me.

BTW, in you are going to rebase the commit, it would be good idea to add
Cc: <stable@vger.kernel.org> to the changelog.

Thanks,
Michal
