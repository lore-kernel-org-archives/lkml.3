Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaBKW3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:29:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42255 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBKW3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:29:38 -0500
Message-ID: <1392157761.13418.26.camel@fourier>
Subject: Re: [PATCH 3.8 070/124] x86: Add check for number of available
 vectors before CPU down
From: Kamal Mostafa <kamal@canonical.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team <kernel-team@lists.ubuntu.com>,
        Andi Kleen <ak@linux.intel.com>, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Gong Chen <gong.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Tue, 11 Feb 2014 14:29:21 -0800
In-Reply-To: <52F973E0.7030400@redhat.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
	 <1392061264-28124-71-git-send-email-kamal@canonical.com>
	 <52F973E0.7030400@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 19:50 -0500, Prarit Bhargava wrote:
> 
> On 02/10/2014 02:40 PM, Kamal Mostafa wrote:
> > 3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.
> > 
> 
> There are some additional fixes required in this code.  I'll push a stable
> request when they are committed to linux.git.
> 
> P.


Thanks Prarit.  I've dropped this from the 3.8-stable queue:

        Author: Prarit Bhargava <prarit@redhat.com>
        Date:   Mon Jan 13 06:51:01 2014 -0500
        
            x86: Add check for number of available vectors before CPU down
            
            commit da6139e49c7cb0f4251265cb5243b8d220adb48d upstream.
            

 -Kamal


