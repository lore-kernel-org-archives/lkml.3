Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3DLPW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:22:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43390 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3DLPWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:22:25 -0400
Message-ID: <516826AC.20006@wwwdotorg.org>
Date: Fri, 12 Apr 2013 09:22:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Li Haifeng <omycle@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "pandaboard@googlegroups.com" <pandaboard@googlegroups.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Kexec couldn't reboot capture kernel on pandaboard ES with OMAP4460
References: <CAFNq8R5FFUyH+JgjoGc5ctgEfiLvxzi7fzawM7+wFX5nEyTv-w@mail.gmail.com> <51658B1A.6090706@wwwdotorg.org> <CAFNq8R6mRJRygfnYvZgwVWOqsrhrjNUYzyZGU0cVsnE30W_xGg@mail.gmail.com> <5166E289.8070104@wwwdotorg.org> <20130412104528.GE12363@mudshark.cambridge.arm.com>
In-Reply-To: <20130412104528.GE12363@mudshark.cambridge.arm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 04:45 AM, Will Deacon wrote:
...
> Back to the SMP point: Stephen, did you ever get anywhere with that
> disable_nonboot_cpus thread from a few months back? I'm still keen to get
> that working, and I *thought* we had a potential solution...

No, I've been side-tracked on too many other things to follow up on that:-(
