Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3JNQbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:31:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54849 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab3JNQbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:31:33 -0400
Message-ID: <525C1C1E.3050304@zytor.com>
Date: Mon, 14 Oct 2013 09:30:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Cohen <david.a.cohen@linux.intel.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v3 07/10] intel_mid: Added custom device_handler support
References: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com>	 <1381549404-22594-8-git-send-email-david.a.cohen@linux.intel.com>	 <525C15E8.9010201@zytor.com> <1381767415.25528.10.camel@joe-AO722>
In-Reply-To: <1381767415.25528.10.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 09:16 AM, Joe Perches wrote:
> 
> Another option is to #define YA macro to produce the
> SFI_DEV_TYPE_IPC, 1, ... NULL that's common to all of them.
> 

That changes in the next patch, and it wasn't true outside of the
subpart of the patch that I quoted, either.

	-hpa


