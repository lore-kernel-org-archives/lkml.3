Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaFETYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:24:24 -0400
Received: from tango.0pointer.de ([85.214.72.216]:33384 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaFETYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:24:23 -0400
Date: Thu, 5 Jun 2014 21:24:21 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, luto@mit.edu,
        Keir Fraser <keir@xen.org>, Tim Deegan <tim@xen.org>,
        Ian Jackson <ian.jackson@eu.citrix.com>, linux-kernel@vger.kernel.org,
        systemd-devel@lists.freedesktop.org,
        linux-security-module@vger.kernel.org, ebiederm@xmission.com,
        Jan Beulich <jbeulich@suse.com>, xen-devel@lists.xenproject.org,
        morgan@kernel.org
Subject: Re: [systemd-devel] [PATCH v5 12/14] autoconf: xen: enable
 	explicit  preference option for xenstored preference
Message-ID: <20140605192421.GA6248@tango.0pointer.de>
References: <1400687040.7272.28.camel@kazak.uk.xensource.com>
 <20140521230233.GA13289@wotan.suse.de>
 <1400753147.14637.10.camel@kazak.uk.xensource.com>
 <20140523232031.GA26450@wotan.suse.de>
 <1401269449.24800.7.camel@kazak.uk.xensource.com>
 <20140529232918.GG26450@wotan.suse.de>
 <20140601061547.GC16257@tango.0pointer.de>
 <20140605003103.GB22052@wotan.suse.de>
 <20140605112213.GA17673@tango.0pointer.de>
 <20140605180137.GD22052@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605180137.GD22052@wotan.suse.de>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05.06.14 20:01, Luis R. Rodriguez (mcgrof@suse.com) wrote:

> > Hmm? You should "exec" the real daemon binary at the end, not just fork
> > it off. That wait the shell script process is replaced by the daemon
> > binary, which is what you want.
> 
> I tried both just running it and also running exec foo; both presented
> the same issue given that shell exec does not really execve.

Hmmm? You shell's "exec" command doesn't actually execve()? What are you
using? This doesn't sound very accurate...

Lennart

-- 
Lennart Poettering, Red Hat
