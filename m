Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3I3IPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:15:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab3I3IPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:15:43 -0400
Date: Mon, 30 Sep 2013 09:15:11 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Eduardo Habkost <ehabkost@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        qemu-devel@nongnu.org, libvir-list@redhat.com,
        Jiri Denemark <jdenemar@redhat.com>
Subject: Re: qemu, numa: non-contiguous cpusets
Message-ID: <20130930081511.GB23756@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20130929151044.GB5426@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130929151044.GB5426@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 05:10:44PM +0200, Borislav Petkov wrote:
> Btw,
> 
> while I got your attention, on a not-really related topic: how do we
> feel about adding support for specifying a non-contiguous set of cpus
> for a numa node in qemu with the -numa option? I.e., like this, for
> example:
> 
> x86_64-softmmu/qemu-system-x86_64 -smp 8 -numa node,nodeid=0,cpus=0\;2\;4-5 -numa node,nodeid=1,cpus=1\;3\;6-7
> 
> The ';' needs to be escaped from the shell but I'm open for better
> suggestions.

Use a ':' instead.

Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
