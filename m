Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3AYD5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:57:50 -0500
Received: from nctlincom01.orcon.net.nz ([60.234.4.69]:47126 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3AYD5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:57:47 -0500
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2013 22:57:47 EST
Cc: Rik van Riel <riel@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Matt Turner <mattst88@gmail.com>, David Howells <dhowells@redhat.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org
Message-Id: <43E02291-8F84-40CD-B429-847E7533EA18@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Michel Lespinasse <walken@google.com>
In-Reply-To: <1357694895-520-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 2/8] mm: use vm_unmapped_area() on alpha architecture
Date: Fri, 25 Jan 2013 16:49:58 +1300
References: <1357694895-520-1-git-send-email-walken@google.com> <1357694895-520-3-git-send-email-walken@google.com>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx3.orcon.net.nz on Fri, 25 Jan 2013 16:50:29 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Jan 25 16:50:32 2013
X-DSPAM-Confidence: 0.6515
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: -3.00 () [Hold at 4.00] CC(NZ:-3)
X-CanIt-Geo: ip=130.217.188.11; country=NZ; region=G1; city=Hamilton; latitude=-37.7833; longitude=175.2833; http://maps.google.com/maps?q=-37.7833,175.2833&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06IQ3Ow2t - 3ea933d36055 - 20130125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/01/2013, at 2:28 PM, Michel Lespinasse wrote:
> Update the alpha arch_get_unmapped_area function to make use of
> vm_unmapped_area() instead of implementing a brute force search.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

'Tis running fine on my alpha.

Tested-by: Michael Cree <mcree@orcon.net.nz>

Cheers
Michael.

