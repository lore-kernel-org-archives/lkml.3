Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab3F1Et2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 00:49:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3F1Et0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 00:49:26 -0400
Message-ID: <1372394950.5989.128.camel@marge.simpson.net>
Subject: Re: cgroup: status-quo and userland efforts
From: Mike Galbraith <bitbucket@online.de>
To: Tejun Heo <tj@kernel.org>
Cc: Tim Hockin <thockin@hockin.org>, Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 06:49:10 +0200
In-Reply-To: <20130628040930.GC2500@htj.dyndns.org>
References: <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
	 <20130422214159.GG12543@htj.dyndns.org>
	 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
	 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
	 <20130625000118.GT1918@mtj.dyndns.org>
	 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
	 <20130626212047.GB4536@htj.dyndns.org>
	 <1372311907.5871.78.camel@marge.simpson.net>
	 <20130627180143.GD5599@mtj.dyndns.org>
	 <1372391198.5989.110.camel@marge.simpson.net>
	 <20130628040930.GC2500@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:03QzSHLDs5Bcp4esbLSOKdmnCLB8wO4FF52STErJGAU
 5xg0YgCpWMVzYuY8EUMGxVMJUwVIYDd8p18aZWWha7EteWF1En
 oaqU9YaPWpuNLtuqezR/C1hlRYkPLCpMRh1DutIutTSXp95p0M
 eBSKZhAVxYmGgSDrP0FfgcuLSBO97JmmlX5Lh+a0NKJ21UEHsu
 u9iWdnlnlah1V8gXfs33u5eEBx9wo0xlzsZwfyUBC9QVUwFOZn
 n1ZKbcghBABAkVXN8cGSfC0Y8B1Lrw1ZYthT+/7p+ZxHOmpUAm
 vYumlIKv680ufGAzMhT8N8p7esWQIszif9MLqlcG03UNcriyEW
 3zfBpcLSC31uIUo2KJ10SMMpyH0DPSfue4crET6/a18UNI85gb
 2mfSry32tuB9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 21:09 -0700, Tejun Heo wrote:

> No, it's completely messed up.  We're now starting to see users trying
> to embed low level cgroup details into their binaries and cgroup is
> exposing sysctl-level konbs which are directly tied to internal
> implementation of core subsystems.  cgroup successfully bypassed the
> usual kernel API policing with the help of hierarchical filesystem
> interface which allows delegation on the surface.  We completely
> fucked up.  This is a full scale disaster unrolling.

I always thought that was a very cool feature, mkdir+echo, poof done.
Now maybe that interface is suboptimal for serious usage, but it makes
the things usable via dirt simple scripts, very flexible, nice.

But whatever, not my call, you know your business better than I.  If
mandatory agent happens, fine, but imho that will be sad day.

-Mike

