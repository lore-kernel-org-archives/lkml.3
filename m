Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3C2HaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 03:30:10 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:55053 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3C2HaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 03:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1303290720350.2023@localhost6.localdomain6>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
 <20130328083943.01e61b4b@jbarnes-desktop> <alpine.DEB.2.02.1303281718490.1928@hadrien>
 <CAB=NE6WbNwPqEPYsASAPaECe4qbAWdd4=eJ402ib+CzZbT69=g@mail.gmail.com>
 <alpine.DEB.2.02.1303281909570.1928@hadrien> <CAB=NE6VPRu8DvneVdwd=pXF0ngi5OifNTpZtX3pLi50i116_OA@mail.gmail.com>
 <alpine.DEB.2.02.1303282328200.2022@localhost6.localdomain6>
 <CAB=NE6WX5Dv9p2jrNwe9GxfH=EUm596uvSspsLQ5-Uuonc6Fqg@mail.gmail.com> <alpine.DEB.2.02.1303290720350.2023@localhost6.localdomain6>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 29 Mar 2013 00:29:44 -0700
X-Google-Sender-Auth: Jd4C-ktBfnXrNm-xx5KrQ9l1juM
Message-ID: <CAB=NE6U2-4uc90p5Os1kUp6QWChMcjarCMR7af0g=XUbGEXjGg@mail.gmail.com>
Subject: Re: [PATCH] compat/compat-drivers/linux-next: fb skip_vt_switch
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        florianschandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        cocci@systeme.lip6.fr,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rodrigo.vivi" <rodrigo.vivi@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "rafael.j.wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 11:21 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>> > I looked in today's linux-next, and there seems to be only one
>> > initialization of this field, to true, and one test of this field.  So
>> > perhaps the case for setting the field to false just isn't needed.
>>
>> Oh sorry now I get what you mean! I thought about this -- and yes I
>> decided to not add a bool false setting for the structure field given
>> that the assumption is this would not be something dynamic, and data
>> structure would be kzalloc()'d so by default they are 0.
>
> What do you do about the test, though?

Return the value.

  Luis
