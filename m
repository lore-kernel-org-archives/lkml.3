Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966570Ab3DQO5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:57:37 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:53352 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966849Ab3DQO5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:57:25 -0400
Date: Tue, 16 Apr 2013 21:15:06 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC 5/7] Docs: Expectations for bug reporters and maintainers
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <412f8f434c32c557b8c17e73163d003b895e2e56.1366046390.git.sarah.a.sharp@linux.intel.com>
	(from sarah.a.sharp@linux.intel.com on Mon Apr 15 12:33:34 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1366164906.18069.110@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 12:33:34 PM, Sarah Sharp wrote:
> Outline how often it's polite to ping kernel maintainers about bugs,  
> and
> suggest that kernel maintainers should respond to bugs in 1 to 5
> business days.

Is there anything in here about the four-level nature of modern  
maintainership?

Patches go from the developer, to the maintainer, to one of Linus's  
lieutenants, to Linus himself. If you submit a patch to a maintainer  
they owe you a response. The lieutenant (subsystem maintainer) owes  
that maintainer a response, and Linus (the project's architect) owes  
the lieutenant a response.

Linus does not owe you, personally, a response. Neither do the  
subsystem maintainers if you approach them directly with something that  
should have gone through one of the hundreds of domain-specific  
maintainers out of the Maintainers file. So the point of going to the  
right people in sequence and getting their review and signed-off-by  
lines is to ensure you don't sit there listening to crickets chirping  
while your patch is ignored. (If you approach Linus directly you may  
randomly _get_ a response, but there's no guarantee, and usually you  
won't because he's really busy.)

Rob