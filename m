Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3KPD4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 22:56:18 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:60291 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3KPD4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 22:56:10 -0500
Date: Fri, 15 Nov 2013 19:56:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 01/28] rcutorture: Add KVM-based test
 framework
Message-ID: <20131116035603.GA4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131116010528.GA9112@kroah.com>
 <20131116012116.GZ4138@linux.vnet.ibm.com>
 <20131115204727.4b7b130d@gandalf.local.home>
 <20131116020120.GA10462@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131116020120.GA10462@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111603-1344-0000-0000-0000034D18B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 06:01:20PM -0800, Greg KH wrote:
> On Fri, Nov 15, 2013 at 08:47:27PM -0500, Steven Rostedt wrote:
> > On Fri, 15 Nov 2013 17:21:16 -0800
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > 
> > > > Oh, one very minor comment on the patches, you should delete the address
> > > > of the FSF from your file headers, unless you want to track the office
> > > > movements of them for the next 40+ years.  We've been removing them from
> > > > kernel code where we notice them, as half of them are wrong, and I don't
> > > > want to have to go back and fix them again when they move again.
> > > 
> > > I had no idea that they tend to move!  Thank you, I will remove them.
> > 
> > From what I've been told, you should replace:
> > 
> > 
> > # You should have received a copy of the GNU General Public License
> > # along with this program; if not, write to the Free Software
> > # Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
> > USA.
> > 
> > With:
> > 
> > # You should have received a copy of the GNU General Public License
> > # along with this program; if not, see  <http://www.gnu.org/licenses>
> 
> But of course, check with your company lawyer for the specific wording,
> I know each one of them like to phrase is all a little bit differently
> (lawyers have to feel useful in some way...)

I get it, no problem!

# You should have received a copy of the GNU General Public License
# along with this program; if not, contact my lawyer.

							Thanx, Paul

