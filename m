Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaIWIX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:23:26 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:38772 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaIWIXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:23:22 -0400
Message-ID: <54212DEE.2090309@redhat.com>
Date: Tue, 23 Sep 2014 10:23:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>
CC: David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
References: <1411167805-2458-1-git-send-email-dmatlack@google.com> <541FFEDE.9030800@redhat.com> <542027F6.4050205@de.ibm.com> <542032D4.305@redhat.com> <54207668.3030502@de.ibm.com> <5420788F.9050208@redhat.com> <20140923064918.GE30733@minantech.com> <542129F1.1080608@de.ibm.com>
In-Reply-To: <542129F1.1080608@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/09/2014 10:06, Christian Borntraeger ha scritto:
> Yes. Davids explanation also makes sense as a commit message. Paolo,
> if you use David patch with a better description of the "why" I am
> fine with this patch.

Done, thanks everybody!

Paolo
