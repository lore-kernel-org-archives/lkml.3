Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaJPRC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJPRC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:02:57 -0400
Date: Thu, 16 Oct 2014 13:02:36 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [PATCH v1 01/10] audit: Remove "weak" from
 audit_classify_compat_syscall() declaration
Message-ID: <20141016170236.GE15532@madcap2.tricolour.ca>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170547.4063.99053.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <CAErSpo5zdt4MrxJaAyAoDQXAimAL_Tk4Q5-zFoBSsTTpmU7ecw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5zdt4MrxJaAyAoDQXAimAL_Tk4Q5-zFoBSsTTpmU7ecw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/15, Bjorn Helgaas wrote:
> [+cc AKASHI, Richard; sorry, I botched my "stg mail" so you weren't
> included the first time]

Makes sense, ACK.

> On Wed, Oct 15, 2014 at 11:05 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > There's only one audit_classify_compat_syscall() definition, so it doesn't
> > need to be weak.
> >
> > Remove the "weak" attribute from the audit_classify_compat_syscall()
> > declaration.
> >
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > CC: AKASHI Takahiro <takahiro.akashi@linaro.org>
> > CC: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 22cfddb75566..1b6098beb46b 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -86,7 +86,7 @@ extern unsigned compat_dir_class[];
> >  extern unsigned compat_chattr_class[];
> >  extern unsigned compat_signal_class[];
> >
> > -extern int __weak audit_classify_compat_syscall(int abi, unsigned syscall);
> > +extern int audit_classify_compat_syscall(int abi, unsigned syscall);
> >
> >  /* audit_names->type values */
> >  #define        AUDIT_TYPE_UNKNOWN      0       /* we don't know yet */

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
