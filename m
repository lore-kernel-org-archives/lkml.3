Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbaGNWsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:48:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:40045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914AbaGNWsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:48:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,661,1400050800"; 
   d="scan'208";a="456925443"
Message-ID: <53C45E1D.3060607@linux.intel.com>
Date: Mon, 14 Jul 2014 15:47:57 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Fengguang Wu <fengguang.wu@intel.com>
CC: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, kaslr] BUG: unable to handle kernel NULL pointer dereference
 at 00000008
References: <20140706022357.GA7349@localhost> <CAGXu5jK2GWXkReO9fKg7aFE5Ds1xyYw2weDpYOvvQntymKn78A@mail.gmail.com>
In-Reply-To: <CAGXu5jK2GWXkReO9fKg7aFE5Ds1xyYw2weDpYOvvQntymKn78A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 02:53 PM, Kees Cook wrote:
> Hi,
> 
> On Sat, Jul 5, 2014 at 7:23 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> Hi Kees,
>>
>> This bug is a bit old (and not very reproducible), however it's still
>> showing up in the upstream and linux-next trees.
> 
> I'm still unable to reproduce this. It feels like it's something
> specific to the qemu loader, maybe?
> 
> -Kees

The Qemu loader is about as dirt simple as it gets...

	-hpa


