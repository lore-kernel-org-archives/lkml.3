Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaCQRMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:12:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36920 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaCQRMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:12:36 -0400
Message-ID: <53272CED.4010901@zytor.com>
Date: Mon, 17 Mar 2014 10:12:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        George Dunlap <George.Dunlap@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Sarah Newman <srn@prgmr.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com> <531DEB11.2070709@zytor.com> <531DF319.6010800@citrix.com> <53266841.6090308@prgmr.com> <1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com> <CAFLBxZZz4Ot0CgWRHNRaM5zVkpf+QdXveFz_m3aVYnKUd9cAdQ@mail.gmail.com> <5327291D.60009@zytor.com> <532739810200007800124E85@nat28.tlf.novell.com>
In-Reply-To: <532739810200007800124E85@nat28.tlf.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 10:05 AM, Jan Beulich wrote:
> 
> I don't think so - while it (as we now see) disallows certain things
> inside the guest, back at the time when this was designed there was
> no sign of any sort of allocation/scheduling being done inside the
> #NM handler. And furthermore, a PV specification is by its nature
> allowed to define deviations from real hardware behavior, or else it
> wouldn't be needed in the first place.
> 

And this is exactly the sort of thing about Xen that make me want to go
on murderous rampage.  You think you can just take the current Linux
implementation at whatever time you implement the code and later come
back and say "don't change that, we hard-coded it in Xen."

Calling that "active negligence and incompetence" is probably on the
mild side.

	-hpa


