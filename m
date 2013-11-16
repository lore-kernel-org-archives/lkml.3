Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3KPBrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 20:47:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:15247 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752476Ab3KPBrb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 20:47:31 -0500
Date: Fri, 15 Nov 2013 20:47:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 01/28] rcutorture: Add KVM-based test
 framework
Message-ID: <20131115204727.4b7b130d@gandalf.local.home>
In-Reply-To: <20131116012116.GZ4138@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
	<1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<20131116010528.GA9112@kroah.com>
	<20131116012116.GZ4138@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013 17:21:16 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> > Oh, one very minor comment on the patches, you should delete the address
> > of the FSF from your file headers, unless you want to track the office
> > movements of them for the next 40+ years.  We've been removing them from
> > kernel code where we notice them, as half of them are wrong, and I don't
> > want to have to go back and fix them again when they move again.
> 
> I had no idea that they tend to move!  Thank you, I will remove them.

>From what I've been told, you should replace:


# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
USA.

With:

# You should have received a copy of the GNU General Public License
# along with this program; if not, see  <http://www.gnu.org/licenses>


-- Steve
