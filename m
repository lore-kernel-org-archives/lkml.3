Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaIVT3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:29:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaIVT33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:29:29 -0400
Message-ID: <5420788F.9050208@redhat.com>
Date: Mon, 22 Sep 2014 21:29:19 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        David Matlack <dmatlack@google.com>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
References: <1411167805-2458-1-git-send-email-dmatlack@google.com> <541FFEDE.9030800@redhat.com> <542027F6.4050205@de.ibm.com> <542032D4.305@redhat.com> <54207668.3030502@de.ibm.com>
In-Reply-To: <54207668.3030502@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2014 21:20, Christian Borntraeger ha scritto:
> "while using trinity to fuzz KVM, we noticed long stalls on invalid ioctls. Lets bail out early on invalid ioctls". or similar?

Okay.  David, can you explain how you found it so that I can make up my
mind?

Gleb and Marcelo, a fourth and fifth opinion? :)

Paolo
