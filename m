Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBYVKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:10:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60082 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbaBYVKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:10:23 -0500
Message-ID: <530D068E.4040700@zytor.com>
Date: Tue, 25 Feb 2014 13:09:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz
Subject: Re: [PATCH 07/11] kexec: Create a relocatable object called purgatory
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com> <1390849071-21989-8-git-send-email-vgoyal@redhat.com> <530B989B.8010507@zytor.com> <20140225164342.GC2701@redhat.com> <530CCB0E.3060009@zytor.com> <20140225182002.GD2701@redhat.com>
In-Reply-To: <20140225182002.GD2701@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 10:20 AM, Vivek Goyal wrote:
> 
> Please let me know if you don't like the idea and you still think there
> should be a shared implementation between arch/x86/boot/ and
> arch/x86/purgatory/.
> 

That is what I would *prefer*.  There are some other string functions in
arch/x86/boot/string.c which also ought to be sharable (and are in
places already.)

	-hpa

