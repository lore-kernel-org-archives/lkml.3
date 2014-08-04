Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaHDXUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:20:06 -0400
Received: from wm51.inbox.com ([64.135.83.51]:2051 "HELO WM51.inbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752583AbaHDXUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:20:04 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2014 19:20:04 EDT
DomainKey-Signature: q=dns; a=rsa-sha1; c=nofws;
 d=inbox.com; s=s1;
 h=mime-version:date:message-id:from:subject:to:content-type;
 b=CFdUwbYussHxd4zCR6QF9B0xxnrCJxPHL/5VZFfdhI+p5tazGmuVIisnGRHyBFTLmwy1
 rrjAFqcIXzMbjLduLKdfPJ62LjHVt0gfzhX7PART3E4bkayVWRgU3Wy8EYA65K0kGFX/wB
 9wd9YBlG2ku5pZaT7mPLXjoB71a/5EIrg=
Mime-Version: 1.0
Date: Mon, 4 Aug 2014 15:09:45 -0800
Message-ID: <E0D42739B2B.0000096Cdaniel_j_hoffman@inbox.com>
From: Daniel Hoffman <daniel_j_hoffman@inbox.com>
Subject: What binutils version is needed for kernel LTO
To: linux-kernel@vger.kernel.org
X-Mailer: INBOX.COM
X-Originating-IP: 96.35.22.142
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-IWM-ACU: QCFFQwW0F_LOMAH4oAHuC_rSBxdiFEo7C2992wnfvj1Jov42ls2R3_OLeiQC
  ixiDns-UsgSIX4UuNRjV_93B-ojLxdEC7JPc10XVM0C69YkT6eMjkw2btatZ
  apVZvwp4NIunNrmK0PJKD5OH9xxo@
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hate to ask it here but I cannot for the life of me compile linux with these. It always kicks it back and says "scripts/Makefile.lto:76: "WARNING: Too old linker version  for kernel LTO. You need Linux binutils. CONFIG_LTO disabled."". I am running the latest version from Ubuntu and it matches up with the latest version from gnu.org. What do I have to do?

____________________________________________________________
FREE ONLINE PHOTOSHARING - Share your photos online with your friends and family!
Visit http://www.inbox.com/photosharing to find out more!


