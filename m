Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3IWPF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:05:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3IWPF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:05:26 -0400
Message-ID: <524058C1.3050006@redhat.com>
Date: Mon, 23 Sep 2013 17:05:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 0/3] KVM: Make kvm_lock non-raw
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com> <20130922074238.GG25202@redhat.com> <523EAFFA.6060203@redhat.com> <20130922095348.GJ25202@redhat.com> <524043C5.70700@windriver.com> <524045B5.5020308@redhat.com> <20130923145925.GA10353@redhat.com>
In-Reply-To: <20130923145925.GA10353@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/09/2013 16:59, Gleb Natapov ha scritto:
> > Perfect, I'll queue [v2 of] these patches for 3.12 then.
> 
> Why 3.12 if it is not going to stable?

Off-by-one. :)

Paolo
