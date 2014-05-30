Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbaE3Npi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:45:38 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50950 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761AbaE3NpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:45:17 -0400
Message-ID: <53888B65.40806@redhat.com>
Date: Fri, 30 May 2014 15:45:09 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, kvm-ia64@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: does anybody still care about kvm-ia64?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was thinking of removing it in Linux 3.17.  I'm not even sure it 
compiles right now, hasn't seen any action in years, and all open-source 
userspace code to use it has been dead for years.

If you disagree, please speak up loudly in the next month.

Paolo
