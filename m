Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3CUL2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:28:52 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:64606 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755302Ab3CUL2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:28:40 -0400
Message-ID: <1363865317.1390.121.camel@x61.thuisdomein>
Subject: Re: [PATCH] [TRIVIAL] removed outdated 'noresidual' parameter
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 12:28:37 +0100
In-Reply-To: <1363863720.1390.109.camel@x61.thuisdomein>
References: <1363863720.1390.109.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 11:28:38.0391 (UTC) FILETIME=[3B7C6070:01CE2627]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 12:02 +0100, Paul Bolle wrote:
> The PPC specific kernel parameter 'noresidual' was removed in v2.6.27,
> though commit 917f0af9e5a9ceecf9e72537fabb501254ba321d ("powerpc: Remove
> arch/ppc and include/asm-ppc").

s/though/through/


Paul Bolle

