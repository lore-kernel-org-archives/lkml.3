Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3BVI4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:56:34 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:35907 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab3BVI4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:56:32 -0500
Message-ID: <512732BE.60503@c-s.fr>
Date: Fri, 22 Feb 2013 09:56:30 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Unset LANG in setlocalversion script
References: <201302211249.r1LCno6O024776@localhost.localdomain> <51268E25.6070104@suse.cz>
In-Reply-To: <51268E25.6070104@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 21/02/2013 22:14, Michal Marek a écrit :
> Dne 21.2.2013 13:49, Christophe Leroy napsal(a):
>> This patch allows the use of setlocalversion script regardless of the LANG
>> parameter. Otherwise, the `svn info 2>/dev/null | grep '^Last Changed Rev'`
>> returns nothing because for instance, in French the text 'Last Changed Rev'
>> is replaced by 'Révision de la dernière modification'
> Unsetting LANG might not be enough. You should unset LC_ALL and set
> LC_MESSAGES=C. But - is this a problem for other commands in the script?
>  From a quick look, we only parse English output of svn, so I suggest to
> only set the env var for the svn command.
>
> Michal
>

Ok, I will propose a new patch.
I confirm my only issue at the time being is with the svn command.

Christophe
