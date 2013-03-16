Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3CPP7I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 11:59:08 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:65404 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3CPP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 11:59:06 -0400
Message-ID: <514496D4.4090009@gmail.com>
Date: Sat, 16 Mar 2013 11:59:16 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
References: <20130307052854.GA23745@redhat.com> <20130307060230.GA31738@kroah.com> <20130307062626.GA25095@redhat.com> <51429D7A.30906@gmail.com> <5142ABD3.4040106@gmail.com> <CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com> <CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com> <51448AC9.7080105@gmail.com> <CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com>
In-Reply-To: <CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 11:22 AM, Ming Lei wrote:
> On Sat, Mar 16, 2013 at 11:07 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>
>> Hi Ming,
>>
>> With your patch:
>>
>>
>> [ 1525.874312] release_sysfs_dirent sysfs_dirent use after free: ptysb-uevent
> 
> Sasha, thanks for your test.
> 
> So is the oops always triggered on this node of 'ptysb-uevent' or the node name
> is changed every time?

Hi Ming,

Looks like it's a different one every time. Just got one on ad7266-unbind.


Thanks,
Sasha
