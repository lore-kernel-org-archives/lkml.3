Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3IKNqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:46:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab3IKNqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:46:16 -0400
Date: Wed, 11 Sep 2013 09:45:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com,
        matthew.garrett@nebula.com, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 15/16] bootparam: Pass acpi_rsdp pointer in bootparam
Message-ID: <20130911134534.GB15364@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
 <1378849471-10521-16-git-send-email-vgoyal@redhat.com>
 <522FA2A8.8080703@zytor.com>
 <20130911114419.GB31551@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911114419.GB31551@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 01:44:19PM +0200, Borislav Petkov wrote:
> On Tue, Sep 10, 2013 at 03:52:24PM -0700, H. Peter Anvin wrote:
> > Borislav Petkov has been working on a fixed mapping of UEFI memory,...
> 
> ... who will back from vacation on Monday and will be sending out a new
> RFC version.

Hi Boris,

I am looking forward to that new version. CCing Dave Young. He is also 
looking into it and going through history of patches.

Thanks
Vivek
