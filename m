Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaHELkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:40:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbaHELkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:40:02 -0400
Message-ID: <53E0C27B.1020503@redhat.com>
Date: Tue, 05 Aug 2014 13:39:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        James Hogan <james.hogan@imgtec.com>
CC: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the kvm tree
References: <20140804180403.3cfdbadf@canb.auug.org.au>	<53E0AB44.90804@imgtec.com> <20140805201342.6b8a8ca4@canb.auug.org.au>
In-Reply-To: <20140805201342.6b8a8ca4@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/08/2014 12:13, Stephen Rothwell ha scritto:
>> > And I suppose it'd be nice to replace tabs with spaces for consistency
>> > (since that's one of the things bf5590f37919 did).
>> > 
>> > How about this fixup patch?
> Thanks for that I have applied it to my merge resolution.

I've now merged kvm-ppc and kvm-arm into kvm, so everything should be
fixed tomorrow.  All conficts should be gone, and the build failure on
PPC too.

Thanks for your work on linux-next, Stephen.

Paolo
