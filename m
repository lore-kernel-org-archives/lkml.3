Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3IKOnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:43:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44060 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3IKOny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:43:54 -0400
Date: Wed, 11 Sep 2013 16:44:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aravind.Gopalakrishnan@amd.com
Subject: Re: amd64_edac: Add ECC decoding support for newer F15h models
Message-ID: <20130911144429.GA1376@x1.alien8.de>
References: <20130904185224.67DFF660948@gitolite.kernel.org>
 <20130905144353.GB15894@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130905144353.GB15894@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 10:43:53AM -0400, Dave Jones wrote:
> Channel will never be < 0, as it's unsigned.

Yes, Aravind, please take care of this.

Thanks.

-- 
Regards/Gruss,
Boris.
