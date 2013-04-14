Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab3DNGAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 02:00:25 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:43274 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3DNGAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 02:00:23 -0400
Message-ID: <516A45BE.5040106@gmail.com>
Date: Sun, 14 Apr 2013 13:59:26 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Chen Gang <gang.chen@asianux.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: acct: kfree, also set related variable to NULL
 after kfree
References: <51652E31.7090806@asianux.com> <20130412142949.GA21714@austin.hallyn.com>
In-Reply-To: <20130412142949.GA21714@austin.hallyn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月12日 22:29, Serge E. Hallyn wrote:
> Quoting Chen Gang (gang.chen@asianux.com):
>> > 
>> >   after kfree acct, also set ns->bacct to NULL.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> 

  thanks.

-- 
Chen Gang

Flying Transformer
