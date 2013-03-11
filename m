Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3CKWFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:05:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44601 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab3CKWFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:05:22 -0400
Message-ID: <513E551D.1070402@wwwdotorg.org>
Date: Mon, 11 Mar 2013 16:05:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?TWFyY2luIMWabHVzYXJ6?= <marcin.slusarz@gmail.com>
CC: Joe Perches <joe@perches.com>, dri-devel@lists.freedesktop.org,
        Borislav Petkov <bp@alien8.de>, linux-tegra@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] get_maintainer: use filename-only regex match for
 Tegra
References: <1363033149-7839-1-git-send-email-swarren@wwwdotorg.org> <CA+GA0_sCXOScRTJMiuz1NkP6uGaB6kkVD4qG+WaOFRyAB-r2NA@mail.gmail.com>
In-Reply-To: <CA+GA0_sCXOScRTJMiuz1NkP6uGaB6kkVD4qG+WaOFRyAB-r2NA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 03:36 PM, Marcin Ślusarz wrote:
> 
> 11 mar 2013 21:19, "Stephen Warren" <swarren@wwwdotorg.org
> <mailto:swarren@wwwdotorg.org>> napisał(a):
>> Create a new N: entry type in MAINTAINERS which performs a regex match
>> against filenames; either those extracted from patch +++ or --- lines,
>> or those specified on the command-line using the -f option.

>> diff --git a/MAINTAINERS b/MAINTAINERS

>> +       N: Files and directories with regex patterns.
>> +          N:   [^a-z]tegra     all files whose patch contains the word tegra
> 
> s/patch/path/ ?

It looks like Andrew has fixed this up himself. Thanks very much!
