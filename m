Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878AbaCTWJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:09:33 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:32843 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933732AbaCTWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:09:30 -0400
Message-ID: <532B6715.7040309@redhat.com>
Date: Thu, 20 Mar 2014 23:09:25 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, gleb@kernel.org, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: ioapic: extract body of kvm_ioapic_set_irq
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>	 <1395154495-22807-4-git-send-email-pbonzini@redhat.com> <1395347109.632.39.camel@ul30vt.home>
In-Reply-To: <1395347109.632.39.camel@ul30vt.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/03/2014 21:25, Alex Williamson ha scritto:
> I might choose to keep the "irq_level" variable name in the new
> functions since dealing with both "edge" and "level" variables is a bit
> confusing.

Good point.  Will rename for v2.

Paolo
