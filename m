Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab3HZI3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:29:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab3HZI3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:29:10 -0400
Message-ID: <521B11C2.3040801@redhat.com>
Date: Mon, 26 Aug 2013 10:28:50 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Yann Droneaud <ydroneaud@opteya.com>
CC: Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH 2/2] ppc: kvm: use anon_inode_getfd() with O_CLOEXEC flag
References: <cover.1377372576.git.ydroneaud@opteya.com> <b7ae23be3a3d4a2f57eca6cfc7f9361da883ceca.1377372576.git.ydroneaud@opteya.com> <3557EF65-4327-4DAE-999A-B0EE13C433F5@suse.de> <521B0622.9090208@redhat.com> <156342996ba92cb5f49519b0c2e9d6ac@meuh.org>
In-Reply-To: <156342996ba92cb5f49519b0c2e9d6ac@meuh.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/08/2013 10:23, Yann Droneaud ha scritto:
> 
> Sounds a lot like InfiniBand subsystem behavor: IB file descriptors
> are of no use accross exec() since memory mappings tied to those fds
> won't be available in the new process:
> 
> https://lkml.org/lkml/2013/7/8/380
> http://mid.gmane.org/f58540dc64fec1ac0e496dfcd3cc1af7@meuh.org

Yes, it is very similar.

Paolo
