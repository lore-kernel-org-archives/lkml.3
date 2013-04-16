Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3DPMTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab3DPMTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:19:33 -0400
Message-ID: <516D41C5.9080009@redhat.com>
Date: Tue, 16 Apr 2013 14:19:17 +0200
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: oss-security@lists.openwall.com
CC: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [oss-security] Summary of security bugs (now fixed) in user namespaces
References: <CALCETrX6Rcv1uMfPdG=K6THusgx-CAjHRkUpMwruBNaZGDvb8Q@mail.gmail.com>
In-Reply-To: <CALCETrX6Rcv1uMfPdG=K6THusgx-CAjHRkUpMwruBNaZGDvb8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2013 07:16 PM, Andy Lutomirski wrote:
> I previously reported these bugs privatley.  I'm summarizing them for
> the historical record.  These bugs were never exploitable on a
> default-configured released kernel, but some 3.8 versions are
> vulnerable depending on configuration.

Looking at this list, is there some way to restrict this new 
functionality to, say, membership in a certain group?  At present, most 
system users (daemons) do not need this functionality, so it would make 
sense to restrict access to it.

Or is the expectation that we disable CONFIG_USER_NS until things 
stabilize further?

-- 
Florian Weimer / Red Hat Product Security Team
