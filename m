Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3EUH1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:27:47 -0400
Received: from mx2.parallels.com ([199.115.105.18]:34457 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab3EUH1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:27:46 -0400
Message-ID: <519B2224.50105@parallels.com>
Date: Tue, 21 May 2013 11:28:36 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Oskar Andero <oskar.andero@sonymobile.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@openvz.org>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Hugh Dickins" <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] mm: vmscan: add VM_BUG_ON on illegal return values
 from scan_objects
References: <1369120410-18180-1-git-send-email-oskar.andero@sonymobile.com> <CAOJsxLGivq0p1j4Axykdz-O8FtYfn=M1BfLEnc=q-fjxA2Yonw@mail.gmail.com>
In-Reply-To: <CAOJsxLGivq0p1j4Axykdz-O8FtYfn=M1BfLEnc=q-fjxA2Yonw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 11:17 AM, Pekka Enberg wrote:
> It seems to me relaxing the shrinker API restrictions and changing the
> "ret == -1" to "ret < 0" would be a much more robust approach...

Dave had already spoken against it, and I agree with him
Anybody returning any negative value different than -1 is definitely
doing something strange


