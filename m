Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaDVTNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:13:53 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:49105 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaDVTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:13:51 -0400
Message-ID: <5356BF6A.2070801@redhat.com>
Date: Tue, 22 Apr 2014 15:13:46 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>
CC: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Check for host supported fields in shadow
 vmcs
References: <jpgk3aiv6a9.fsf@nelium.bos.redhat.com>	<5355E222.7010607@redhat.com> <jpg7g6h72ln.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpg7g6h72ln.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/04/2014 12:25, Bandan Das ha scritto:
>>> >> +		if (j < i)
>>> >> +			shadow_read_write_fields[j] =
>>> >> +				shadow_read_write_fields[i];
>>> >> +		j++;
>> >
>> > ... you need to respin anyway because the j++ is wrong.  It should be
>> > inside the "if".  If you prefer, you can put it in the lhs of the
> j++ outside the "if" looks right to me. Can you please explain why
> you think it shouldn't be that way ?
>

The way you wrote it, j will always be equal to i.

Paolo
