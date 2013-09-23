Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3IWX67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:58:59 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39352 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3IWX65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:58:57 -0400
Date: Mon, 23 Sep 2013 18:58:52 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: Update x86_64/boot-options.txt
To: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, bp@suse.de,
        dave.hansen@linux.intel.com, tony.luck@intel.com,
        naveen.n.rao@linux.vnet.ibm.com, Richard Weinberger <richard@nod.at>
References: <1379965017-29776-1-git-send-email-richard@nod.at>
In-Reply-To: <1379965017-29776-1-git-send-email-richard@nod.at> (from
	richard@nod.at on Mon Sep 23 14:36:57 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1379980732.1974.62@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 02:36:57 PM, Richard Weinberger wrote:
> Removed obsolte parameters from boot-options.txt.
> Verified by grepping around in arch/x86/.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Rob Landley <rob@landley.net>

And added it as patch #33 to my documentation todo heap. Now the merge  
window's worked its way through I should filter out the ones other  
people sent upstream and flush the queue. (Since everybody and their  
dog grabs documentation patches, forwarding 'em promptly just causes  
dupes, but it's about time to see what didn't already make it...)

Rob